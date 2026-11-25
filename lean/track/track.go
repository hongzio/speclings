// Package track is the Lean track of speclings: small, broken Lean files, checked with
// Lean and with the checker in lean/checker/. Exercise order and expectations are in exercises.go.
package track

import (
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/hongzio/speclings/internal/lings"
)

// Track is the Lean track. It implements lings.Track.
type Track struct {
	root string // the repository: lean-toolchain and mise.toml
	dir  string // lean/
}

func New() *Track { return &Track{} }

func (*Track) ID() string { return "lean" }

func (*Track) Title() lings.L {
	return lings.L{"en": "Lean 4: functional programs and proofs", "ko": "Lean 4: 함수형 프로그램과 증명"}
}

func (t *Track) Init(env lings.Env) { t.root, t.dir = env.Root, env.Dir }

func (*Track) Exercises() []lings.Exercise { return view }

// view is exercises as the engine sees them.
var view = func() []lings.Exercise {
	was := map[string][]string{}
	for old, cur := range renamed {
		was[cur] = append(was[cur], old)
	}
	v := make([]lings.Exercise, len(exercises))
	for i, ex := range exercises {
		v[i] = lings.Exercise{Name: ex.Name, Hint: ex.Hint, Nudges: ex.Nudges, Files: []string{ex.file()}, Was: was[ex.Name]}
	}
	return v
}()

func (*Track) SetLang(lang string) {
	if c := catalogs[lang]; c != nil {
		m = c
	}
}

// Prepare fails when there is no lean, warns when it is not the version in lean-toolchain
// (the exercises expect that version's messages), and builds the checker. The build is
// cached, so new exercises never require a reinstall.
func (t *Track) Prepare(ctx context.Context) error {
	have, err := leanVersion(ctx)
	if err != nil {
		return err
	}
	if want, err := toolchainVersion(t.root); err == nil && have != want {
		fmt.Fprintln(os.Stderr, lings.Yellow(fmt.Sprintf(m.VersionMismatch, have, want)))
	}
	cmd := exec.CommandContext(ctx, "lake", "-d", filepath.Join(t.dir, "checker"), "build", "-q")
	cmd.Stdout, cmd.Stderr = os.Stderr, os.Stderr
	if err := cmd.Run(); err != nil {
		return fmt.Errorf(m.CheckerBuild, err)
	}
	return nil
}

func (t *Track) Check(ctx context.Context, c lings.Check) (lings.Report, error) {
	ex := exercises[c.Index]
	work := filepath.Join(c.Dir, ex.file())
	src, err := os.ReadFile(work)
	if err != nil {
		return lings.Report{}, err
	}
	r, err := checkSource(ctx, t.dir, ex, src)
	if err != nil {
		return lings.Report{}, err
	}
	// Lean's messages, as plain lean prints them. They are shown unaltered: learning to read them is part of the tutorial.
	msgs := render(r.Msgs, c.Rel(work), nil) + r.Other
	if r.ok() {
		// After a pass, show the output of the learner's #eval, #check and so on: they
		// wrote them to look at them. Warnings (linters) only with -v.
		if !c.Verbose {
			msgs = render(r.Msgs, c.Rel(work), func(msg Message) bool { return msg.Severity == sevInfo })
		}
		var b strings.Builder
		if msgs != "" {
			b.WriteString("\n" + msgs + lings.Sep() + "\n")
		}
		if ex.Expect.Output != "" {
			b.WriteString(lings.Dim(m.Printed) + "\n" + r.Output + lings.Sep() + "\n")
		}
		return lings.Report{OK: true, Shown: b.String()}, nil
	}
	shown := "\n"
	if msgs != "" {
		shown += msgs + lings.Sep() + "\n"
	}
	return lings.Report{Shown: shown, Problem: r.Problem, Expected: ex.Expect.String()}, nil
}

func (*Track) CodeLines(_, src string) []string { return codeLines(src) }

func (t *Track) VerifySetup(ctx context.Context) bool { return verifyVersions(ctx, t.root) }

func (t *Track) VerifyOriginal(ctx context.Context, i int, lang string) (mark, detail string) {
	return verifyOriginal(ctx, t.dir, exercises[i], lang)
}

func (t *Track) VerifySolution(ctx context.Context, i int) (mark, detail string) {
	return verifySolution(ctx, t.dir, exercises[i])
}
