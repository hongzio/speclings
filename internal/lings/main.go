package lings

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/signal"
	"path/filepath"
	"slices"
	"strings"
	"time"
)

// Main runs the speclings command line with tracks, in learning order, and returns the exit code.
//
//	speclings                      show the tracks and your progress
//	speclings -lang ko             pick a language (saved in the workspace; default en)
//	speclings <track>              check from where you left off; stop at the first failure
//	speclings <track> -n 3         check exercise 3 only
//	speclings <track> -s 3         check in order starting from exercise 3
//	speclings <track> -watch       check again whenever a file in work/<track>/ changes
//	speclings <track> -restore 3   restore exercise 3 to its original state (the old files are kept as .bak)
//	speclings <track> -hint        show the hint for the current exercise (-hint -n 3: for exercise 3)
//	speclings <track> -v           also show the tool's output when a check passes
//	speclings <track> -reset       clear the track's progress
//	speclings verify [track ...]   (authors) check every original, translation and solution
func Main(tracks ...Track) int {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()

	root, err := findRoot()
	check(err)
	for _, t := range tracks {
		dir := filepath.Join(root, t.ID())
		t.Init(Env{Root: root, Dir: dir})
		check(CheckManifest(dir, t.Exercises()))
	}
	w, err := openWorkspace(root)
	check(err)
	setLang(tracks, w.state.Lang)

	top := flag.NewFlagSet("speclings", flag.ExitOnError)
	lang := top.String("lang", "", "language ("+languages()+"); saved in the workspace")
	top.Usage = func() {
		usage(top.Output(), tracks)
		top.PrintDefaults()
	}
	top.Parse(os.Args[1:])
	args := top.Args()

	if len(args) == 0 || args[0] != "verify" { // verify never touches work/
		for _, t := range tracks {
			renamed, err := w.migrate(t)
			for _, r := range renamed {
				fmt.Printf(m.Renumbered+"\n", rel(r[0]), filepath.Base(r[1]))
			}
			check(err)
		}
	}

	switch {
	case len(args) == 0:
		changeLang(w, tracks, *lang)
		overview(w, tracks)
		return 0
	case args[0] == "verify":
		return verify(ctx, root, tracks, *lang, args[1:])
	}
	t := findTrack(tracks, args[0])
	return runTrack(ctx, w, tracks, t, *lang, args[1:])
}

func usage(out io.Writer, tracks []Track) {
	fmt.Fprintf(out, `usage:
  speclings [-lang L]             show the tracks and your progress
  speclings <track> [flags]       work through a track; speclings <track> -h lists its flags
  speclings verify [track ...]    (authors) check every original, translation and solution

tracks: %s

`, ids(tracks))
}

func runTrack(ctx context.Context, w *workspace, tracks []Track, t Track, defaultLang string, args []string) int {
	fs := flag.NewFlagSet("speclings "+t.ID(), flag.ExitOnError)
	lang := fs.String("lang", defaultLang, "language ("+languages()+"); saved in the workspace")
	n := fs.Int("n", 0, "check only exercise `N`")
	s := fs.Int("s", 0, "check in order starting from exercise `N`")
	watch := fs.Bool("watch", false, "check again whenever a file in work/"+t.ID()+"/ changes")
	restore := fs.Int("restore", 0, "restore exercise `N` to its original state (your files are kept as .bak)")
	hint := fs.Bool("hint", false, "show the hint for the current exercise, or for exercise N with -n")
	reset := fs.Bool("reset", false, "clear the track's progress and start again from 001")
	verbose := fs.Bool("v", false, "show the tool's output, warnings included, even when a check passes")
	fs.Parse(args)
	if fs.NArg() > 0 {
		fail(fmt.Errorf("unexpected argument %q", fs.Arg(0)))
	}

	exs := t.Exercises()
	for _, v := range []int{*n, *s, *restore} {
		if v < 0 || v > len(exs) {
			fail(fmt.Errorf(m.OutOfRange, len(exs)))
		}
	}
	changeLang(w, tracks, *lang)
	tu := &tutor{t: t, w: w, verbose: *verbose}

	switch {
	case *hint:
		i := w.nextIndex(t)
		if *n > 0 {
			i = *n - 1
		}
		if i >= len(exs) {
			fmt.Println(m.AllDone)
			return 0
		}
		fmt.Printf(m.HintFor+"\n%s\n", exs[i].Name, exs[i].Hint.In(w.state.Lang))
		return 0
	case *reset:
		delete(w.state.Done, t.ID())
		check(w.save())
		fmt.Println(m.ProgressReset)
		return 0
	case *restore > 0:
		ex := exs[*restore-1]
		backups, err := w.restore(t, ex)
		check(err)
		fmt.Printf(m.Restored+"\n", rel(filepath.Join(w.dir(t), ex.Files[0])))
		for _, b := range backups {
			fmt.Printf("  "+m.BackedUp+"\n", rel(b))
		}
		return 0
	}

	check(t.Prepare(ctx))
	run := func() bool {
		switch {
		case *n > 0:
			return tu.checkOne(ctx, *n-1)
		case *s > 0:
			return tu.checkFrom(ctx, *s-1)
		default:
			return tu.checkFrom(ctx, w.nextIndex(t))
		}
	}
	if !*watch {
		if !run() {
			return 1
		}
		return 0
	}
	for {
		// Take the baseline before checking so that saves made during a check are not missed.
		// Copied files inherit the original's modification time, so they never count as changes.
		before := time.Now()
		run()
		fmt.Println(Dim("\n" + m.WatchWaiting))
		if !tu.waitForChange(ctx, before) {
			return 0
		}
		fmt.Println(Dim(strings.Repeat("━", 72)))
	}
}

// verify runs -verify for the tracks named in args, or for all of them.
func verify(ctx context.Context, root string, tracks []Track, defaultLang string, args []string) int {
	fs := flag.NewFlagSet("speclings verify", flag.ExitOnError)
	lang := fs.String("lang", defaultLang, "language of the report ("+languages()+"); not saved")
	fs.Parse(args)
	if *lang != "" {
		checkLang(*lang)
		setLang(tracks, *lang)
	}
	selected := tracks
	if fs.NArg() > 0 {
		selected = nil
		for _, id := range fs.Args() {
			selected = append(selected, findTrack(tracks, id))
		}
	}
	code := 0
	for i, t := range selected {
		if i > 0 {
			fmt.Println()
		}
		fmt.Printf("== %s: %s\n", t.ID(), t.Title().In(curLang))
		if err := t.Prepare(ctx); err != nil {
			fmt.Printf("%s %v\n", Red("✗"), err)
			code = 1
			continue
		}
		if runVerify(ctx, root, t) != 0 {
			code = 1
		}
	}
	return code
}

// overview shows every track with the learner's progress.
func overview(w *workspace, tracks []Track) {
	fmt.Println(m.Intro)
	fmt.Println()
	width := 0
	for _, t := range tracks {
		width = max(width, len(t.ID()))
	}
	suggest := ""
	for _, t := range tracks {
		exs := t.Exercises()
		i := w.nextIndex(t)
		next := m.TrackDone
		if i < len(exs) {
			next = fmt.Sprintf(m.NextUp, exs[i].Name)
			if suggest == "" {
				suggest = t.ID()
			}
		}
		fmt.Printf("  %-*s  %s\n", width, t.ID(), t.Title().In(curLang))
		fmt.Printf("  %-*s  %s\n", width, "", Dim(fmt.Sprintf("%d/%d · %s", i, len(exs), next)))
	}
	if suggest == "" {
		suggest = tracks[0].ID()
	}
	fmt.Println()
	fmt.Printf(m.HowTo+"\n", suggest)
}

// curLang is the language of the messages, set by setLang.
var curLang = BaseLang

func setLang(tracks []Track, lang string) {
	curLang = lang
	m = catalogs[lang]
	for _, t := range tracks {
		t.SetLang(lang)
	}
}

func checkLang(lang string) {
	if catalogs[lang] == nil {
		fail(fmt.Errorf(m.UnknownLang, lang, languages()))
	}
}

// changeLang switches to lang and saves it, unless lang is "" or already the language.
func changeLang(w *workspace, tracks []Track, lang string) {
	if lang == "" {
		return
	}
	checkLang(lang)
	if lang == w.state.Lang {
		return
	}
	w.state.Lang = lang
	check(w.save())
	setLang(tracks, lang)
	fmt.Printf(m.LangSet+"\n", lang)
	if w.hasExercises(tracks) {
		fmt.Println(m.LangKeep)
	}
}

func findTrack(tracks []Track, id string) Track {
	i := slices.IndexFunc(tracks, func(t Track) bool { return t.ID() == id })
	if i < 0 {
		fail(fmt.Errorf(m.UnknownTrack, id, ids(tracks)))
	}
	return tracks[i]
}

func ids(tracks []Track) string {
	var s []string
	for _, t := range tracks {
		s = append(s, t.ID())
	}
	return strings.Join(s, ", ")
}

func fail(err error) {
	fmt.Fprintln(os.Stderr, "speclings:", err)
	os.Exit(2)
}

func check(err error) {
	if err != nil {
		fail(err)
	}
}

// findRoot finds the repository root. bin/speclings passes it in SPECLINGS_ROOT;
// otherwise it walks up from the current directory to one containing go.mod and cmd/speclings/.
func findRoot() (string, error) {
	if r := os.Getenv("SPECLINGS_ROOT"); r != "" {
		return r, nil
	}
	dir, err := os.Getwd()
	if err != nil {
		return "", err
	}
	for {
		if IsDir(filepath.Join(dir, "cmd", "speclings")) && IsFile(filepath.Join(dir, "go.mod")) {
			return dir, nil
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			return "", errors.New("cannot find the speclings repository (a directory with go.mod and cmd/speclings/)")
		}
		dir = parent
	}
}
