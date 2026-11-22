// tlings is a tutorial runner that checks broken TLA+ specs in order, in the style of ziglings.
//
//	tlings              check from where you left off; stop at the first failure
//	tlings -lang ko     pick a language (saved in the workspace; default en)
//	tlings -n 3         check exercise 3 only
//	tlings -s 3         check in order starting from exercise 3
//	tlings -watch       check again whenever a file in work/ changes
//	tlings -restore 3   restore exercise 3 to its original state (the old file is kept as .bak)
//	tlings -hint        show the hint for the current exercise (-hint -n 3: for exercise 3)
//	tlings -v           also show TLC's output when a check passes
//	tlings -reset       clear progress
//	tlings -verify      (authors) check every original, translation and solution
package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"regexp"
	"strings"
	"time"
)

func main() {
	lang := flag.String("lang", "", "language (en, ko); saved in the workspace")
	n := flag.Int("n", 0, "check only exercise `N`")
	s := flag.Int("s", 0, "check in order starting from exercise `N`")
	watch := flag.Bool("watch", false, "check again whenever a file in work/ changes")
	restore := flag.Int("restore", 0, "restore exercise `N` to its original state (your file is kept as .bak)")
	hint := flag.Bool("hint", false, "show the hint for the current exercise, or for exercise N with -n")
	reset := flag.Bool("reset", false, "clear progress and start again from 001")
	verbose := flag.Bool("v", false, "show TLC's output even when a check passes (automatic if the file uses Print or PrintT)")
	verify := flag.Bool("verify", false, "(authors) check every original, translation and solution")
	flag.Parse()

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	root, err := findRoot()
	if err == nil {
		err = checkManifest(root)
	}
	check(err)
	w, err := openWorkspace(root)
	check(err)
	m = catalogs[w.state.Lang]

	if *lang != "" && catalogs[*lang] == nil {
		fail(fmt.Errorf(m.UnknownLang, *lang, languages()))
	}
	for _, v := range []int{*n, *s, *restore} {
		if v < 0 || v > len(exercises) {
			fail(fmt.Errorf(m.OutOfRange, len(exercises)))
		}
	}
	if *verify {
		if *lang != "" {
			m = catalogs[*lang]
		}
		os.Exit(runVerify(ctx, root))
	}

	if *lang != "" && *lang != w.state.Lang {
		w.state.Lang = *lang
		check(w.save())
		m = catalogs[*lang]
		fmt.Printf(m.LangSet+"\n", *lang)
		if w.hasExercises() {
			fmt.Println(m.LangKeep)
		}
	}
	t := &tutor{w: w, verbose: *verbose}

	switch {
	case *hint:
		i := w.nextIndex()
		if *n > 0 {
			i = *n - 1
		}
		if i >= len(exercises) {
			fmt.Println(m.AllDone)
			return
		}
		fmt.Printf(m.HintFor+"\n%s\n", exercises[i].Name, exercises[i].Hint.in(w.state.Lang))
		return
	case *reset:
		w.state.Done = ""
		check(w.save())
		fmt.Println(m.ProgressReset)
		return
	case *restore > 0:
		ex := exercises[*restore-1]
		backups, err := w.restore(ex)
		check(err)
		fmt.Printf(m.Restored+"\n", t.rel(filepath.Join(w.dir(), ex.Name+".tla")))
		for _, b := range backups {
			fmt.Printf("  "+m.BackedUp+"\n", t.rel(b))
		}
		return
	}

	run := func() bool {
		switch {
		case *n > 0:
			return t.checkOne(ctx, *n-1)
		case *s > 0:
			return t.checkFrom(ctx, *s-1)
		default:
			return t.checkFrom(ctx, w.nextIndex())
		}
	}
	if !*watch {
		if !run() {
			os.Exit(1)
		}
		return
	}
	for {
		// Take the baseline before checking so that saves made during a check are not missed.
		// Copied files inherit the original's modification time, so they never count as changes.
		before := time.Now()
		run()
		fmt.Println(dim("\n" + m.WatchWaiting))
		if !waitForChange(ctx, w.dir(), before) {
			return
		}
		fmt.Println(dim(strings.Repeat("━", 72)))
	}
}

func fail(err error) {
	fmt.Fprintln(os.Stderr, "tlings:", err)
	os.Exit(2)
}

func check(err error) {
	if err != nil {
		fail(err)
	}
}

// findRoot finds the repository root. bin/tlings passes it in TLINGS_ROOT;
// otherwise it walks up from the current directory to one containing exercises/ and go.mod.
func findRoot() (string, error) {
	if r := os.Getenv("TLINGS_ROOT"); r != "" {
		return r, nil
	}
	dir, err := os.Getwd()
	if err != nil {
		return "", err
	}
	for {
		if isDir(filepath.Join(dir, "exercises")) && isFile(filepath.Join(dir, "go.mod")) {
			return dir, nil
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			return "", errors.New("cannot find the tlings root (a directory with exercises/ and go.mod)")
		}
		dir = parent
	}
}

// checkManifest checks that the exercise list matches the original files.
func checkManifest(root string) error {
	for i, ex := range exercises {
		if prefix := fmt.Sprintf("%03d_", i+1); !strings.HasPrefix(ex.Name, prefix) {
			return fmt.Errorf("exercise #%d is named %q; it must start with %q", i+1, ex.Name, prefix)
		}
		for _, f := range ex.files() {
			if p := filepath.Join(root, "exercises", baseLang, f); !isFile(p) {
				return fmt.Errorf("missing %s", p)
			}
		}
	}
	return nil
}

type tutor struct {
	w       *workspace
	verbose bool // show TLC's output even when a check passes
}

// checkFrom checks exercises in order from index i and saves progress after each pass.
func (t *tutor) checkFrom(ctx context.Context, i int) bool {
	for ; i < len(exercises); i++ {
		if !t.checkOne(ctx, i) {
			return false
		}
		t.w.state.Done = exercises[i].Name
		check(t.w.save())
	}
	fmt.Println(green("\n" + m.AllDone))
	return true
}

func (t *tutor) checkOne(ctx context.Context, i int) bool {
	ex := exercises[i]
	fallback, err := t.w.ensure(ex)
	check(err)
	if fallback {
		fmt.Println(dim(ex.Name + " " + m.Fallback))
	}
	fmt.Printf("%s %s ", dim(m.Checking), ex.Name)
	start := time.Now()
	r, err := runTLC(ctx, t.w.dir(), ex.Name)
	if err != nil {
		fmt.Println()
		fmt.Fprintln(os.Stderr, "tlings:", err)
		return false
	}
	ok, why := judge(ex.Expect, r)
	work := filepath.Join(t.w.dir(), ex.Name+".tla")
	if ok {
		if missing := missingAssumes(t.w.root, ex, work); len(missing) > 0 {
			ok, why = false, fmt.Sprintf(m.MissingAssume, strings.Join(missing, "\n"))
		}
	}
	if ok {
		fmt.Printf("%s %s\n", green("✓"), dim(time.Since(start).Round(100*time.Millisecond).String()))
		if t.verbose || usesPrint(work) {
			fmt.Println()
			fmt.Print(r.Output)
			fmt.Println(dim(strings.Repeat("─", 72)))
		}
		return true
	}
	fmt.Println(red("✗"))
	fmt.Println()
	fmt.Print(r.Output)
	fmt.Println(dim(strings.Repeat("─", 72)))
	fmt.Printf("%s %s\n", red("✗"), fmt.Sprintf(m.NeedsFix, ex.Name))
	cont := func(s string) string { return strings.ReplaceAll(s, "\n", "\n"+m.Cont) }
	fmt.Printf("  %s%s\n", m.Result, cont(why))
	fmt.Printf("  %s%s\n", m.Expected, ex.Expect)
	hintCmd := "tlings -hint"
	if i != t.w.nextIndex() {
		hintCmd = fmt.Sprintf("tlings -hint -n %d", i+1)
	}
	fmt.Printf("  %s"+m.HintHow+"\n", m.Hint, hintCmd)
	fmt.Printf("  %s%s\n", m.File, t.rel(work))
	return false
}

// usesPrint reports whether the code of file (comments excluded) calls Print or PrintT.
// Learners use them to look at values, so their output is shown even when the check passes.
func usesPrint(file string) bool {
	b, err := os.ReadFile(file)
	if err != nil {
		return false
	}
	return rePrint.MatchString(strings.Join(codeLines(string(b)), "\n"))
}

var rePrint = regexp.MustCompile(`\bPrintT?\(`)

func (t *tutor) rel(p string) string {
	if wd, err := os.Getwd(); err == nil {
		if r, err := filepath.Rel(wd, p); err == nil && !strings.HasPrefix(r, "..") {
			return r
		}
	}
	return p
}

// waitForChange waits until a .tla or .cfg file in dir is modified after before.
// It returns false if interrupted with Ctrl-C.
func waitForChange(ctx context.Context, dir string, before time.Time) bool {
	tick := time.NewTicker(500 * time.Millisecond)
	defer tick.Stop()
	for {
		select {
		case <-ctx.Done():
			return false
		case <-tick.C:
			if latestMod(dir).After(before) {
				return true
			}
		}
	}
}

func isDir(p string) bool  { fi, err := os.Stat(p); return err == nil && fi.IsDir() }
func isFile(p string) bool { fi, err := os.Stat(p); return err == nil && fi.Mode().IsRegular() }

var color = func() bool {
	fi, err := os.Stdout.Stat()
	return err == nil && fi.Mode()&os.ModeCharDevice != 0 && os.Getenv("NO_COLOR") == ""
}()

func paint(code, s string) string {
	if !color {
		return s
	}
	return "\x1b[" + code + "m" + s + "\x1b[0m"
}

func green(s string) string { return paint("32", s) }
func red(s string) string   { return paint("31", s) }
func dim(s string) string   { return paint("2", s) }
