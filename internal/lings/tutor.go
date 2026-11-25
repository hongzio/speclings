package lings

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"
)

// tutor checks the exercises of one track for the learner.
type tutor struct {
	t       Track
	w       *workspace
	verbose bool // -v: show the tool's output even when a check passes
}

// checkFrom checks exercises in order from index i and saves progress after each pass.
func (tu *tutor) checkFrom(ctx context.Context, i int) bool {
	exs := tu.t.Exercises()
	for ; i < len(exs); i++ {
		if !tu.checkOne(ctx, i) {
			return false
		}
		tu.w.setDone(tu.t, exs[i].Name)
		check(tu.w.save())
	}
	fmt.Println(Green("\n" + m.AllDone))
	return true
}

func (tu *tutor) checkOne(ctx context.Context, i int) bool {
	ex := tu.t.Exercises()[i]
	fallback, err := tu.w.ensure(tu.t, ex)
	check(err)
	if fallback {
		fmt.Println(Dim(ex.Name + " " + m.Fallback))
	}
	fmt.Printf("%s %s ", Dim(m.Checking), ex.Name)
	start := time.Now()
	dir := tu.w.dir(tu.t)
	r, err := tu.t.Check(ctx, Check{Index: i, Dir: dir, Verbose: tu.verbose, Rel: rel})
	if err != nil {
		fmt.Println()
		fmt.Fprintln(os.Stderr, "speclings:", err)
		return false
	}
	if r.OK {
		fmt.Printf("%s %s\n", Green("✓"), Dim(time.Since(start).Round(100*time.Millisecond).String()))
		fmt.Print(r.Shown)
		return true
	}
	fmt.Println(Red("✗"))
	fmt.Print(r.Shown)
	fmt.Printf("%s %s\n", Red("✗"), fmt.Sprintf(m.NeedsFix, ex.Name))
	cont := func(s string) string { return strings.ReplaceAll(s, "\n", "\n"+m.Cont) }
	fmt.Printf("  %s%s\n", m.Result, cont(r.Problem))
	fmt.Printf("  %s%s\n", m.Expected, r.Expected)
	hintCmd := hintCommand(tu.t, i, tu.w.nextIndex(tu.t))
	fmt.Printf("  %s"+m.HintHow+"%s\n", m.Hint, hintCmd, tu.w.hintStatus(tu.t, ex))
	fmt.Printf("  %s%s\n", m.File, rel(filepath.Join(dir, ex.Files[0])))
	return false
}

// rel returns p relative to the current directory if p is inside it.
func rel(p string) string {
	if wd, err := os.Getwd(); err == nil {
		if r, err := filepath.Rel(wd, p); err == nil && !strings.HasPrefix(r, "..") {
			return r
		}
	}
	return p
}

// waitForChange waits until an exercise file of t in work/<track>/ is modified after before.
// It returns false if interrupted with Ctrl-C.
func (tu *tutor) waitForChange(ctx context.Context, before time.Time) bool {
	dir, exts := tu.w.dir(tu.t), extensions(tu.t)
	tick := time.NewTicker(500 * time.Millisecond)
	defer tick.Stop()
	for {
		select {
		case <-ctx.Done():
			return false
		case <-tick.C:
			if latestMod(dir, exts).After(before) {
				return true
			}
		}
	}
}
