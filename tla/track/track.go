// Package track is the TLA+ track of speclings: small, broken TLA+ specs, checked with TLC.
// Exercise order and expectations are in exercises.go.
package track

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/hongzio/speclings/internal/lings"
)

// Track is the TLA+ track. It implements lings.Track.
type Track struct {
	dir string // tla/
}

func New() *Track { return &Track{} }

func (*Track) ID() string { return "tla" }

func (*Track) Title() lings.L {
	return lings.L{"en": "TLA+ and the TLC model checker", "ko": "TLA+ 와 TLC 모델 검사기"}
}

func (t *Track) Init(env lings.Env) { t.dir = env.Dir }

func (*Track) Exercises() []lings.Exercise { return view }

// view is exercises as the engine sees them.
var view = func() []lings.Exercise {
	v := make([]lings.Exercise, len(exercises))
	for i, ex := range exercises {
		v[i] = lings.Exercise{Name: ex.Name, Hint: ex.Hint, Nudges: ex.Nudges, Files: ex.files()}
	}
	return v
}()

func (*Track) SetLang(lang string) {
	if c := catalogs[lang]; c != nil {
		m = c
	}
}

// Prepare has nothing to do: bin/tlc finds the jars, and a missing tlc is reported when a check runs it.
func (*Track) Prepare(context.Context) error { return nil }

func (t *Track) Check(ctx context.Context, c lings.Check) (lings.Report, error) {
	ex := exercises[c.Index]
	r, err := runTLC(ctx, c.Dir, ex.Name)
	if err != nil {
		return lings.Report{}, err
	}
	ok, why := judge(ex.Expect, r)
	work := filepath.Join(c.Dir, ex.Name+".tla")
	if ok {
		if missing := missingAssumes(t.dir, ex, work); len(missing) > 0 {
			ok, why = false, fmt.Sprintf(m.MissingAssume, strings.Join(missing, "\n"))
		}
	}
	shown := "\n" + r.Output + lings.Sep() + "\n"
	if ok {
		// Show TLC's output when asked, when the learner prints values, and when the
		// goal was a counterexample: reading it is part of the exercise.
		if !c.Verbose && !usesPrint(work) && ex.Expect.Kind == Holds {
			shown = ""
		}
		return lings.Report{OK: true, Shown: shown}, nil
	}
	return lings.Report{Shown: shown, Problem: why, Expected: ex.Expect.String()}, nil
}

// CodeLines works for .tla and .cfg files alike.
func (*Track) CodeLines(_, src string) []string { return codeLines(src) }

func (*Track) VerifySetup(context.Context) bool { return true }

func (t *Track) VerifyOriginal(ctx context.Context, i int, lang string) (mark, detail string) {
	return verifyOriginal(ctx, t.dir, exercises[i], lang)
}

func (t *Track) VerifySolution(ctx context.Context, i int) (mark, detail string) {
	return verifySolution(ctx, t.dir, exercises[i])
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
