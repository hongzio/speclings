package track

import (
	"context"
	"errors"
	"fmt"
	"os"
	"path/filepath"

	"github.com/hongzio/speclings/internal/lings"
)

// verifyVersions reports whether lean --version, lean-toolchain and mise.toml (in repo) name the same Lean.
func verifyVersions(ctx context.Context, repo string) bool {
	lv, err1 := leanVersion(ctx)
	tv, err2 := toolchainVersion(repo)
	mv, err3 := miseVersion(repo)
	if err := errors.Join(err1, err2, err3); err != nil {
		fmt.Printf("%s %v\n", lings.Red("✗"), err)
		return false
	}
	if lv != tv || tv != mv {
		fmt.Printf("%s %s\n", lings.Red("✗"), fmt.Sprintf(m.VerifyVersions, lv, tv, mv))
		return false
	}
	fmt.Printf("%s Lean %s\n", lings.Green("✓"), lv)
	return true
}

// verifyOriginal checks that the original in lang fails in the intended way, and fails the check.
// The engine has already checked that it exists and that its code matches en. root is the track's directory, lean/.
func verifyOriginal(ctx context.Context, root string, ex Exercise, lang string) (mark, detail string) {
	src, err := os.ReadFile(filepath.Join(root, "exercises", lang, ex.file()))
	if err != nil {
		return "✗", err.Error()
	}
	if lang == baseLang && reGuardMsgs.MatchString(stripComments(string(src), true)) {
		return "✗", m.VerifyGuardMsgs
	}
	broken := append([]Broken{ex.Broken}, ex.Also...)
	for _, b := range broken {
		if b.At != "" && lineOf(string(src), b.At) == 0 {
			return "✗", fmt.Sprintf(lings.M().VerifyNoSnippet, b.At)
		}
	}
	r, err := checkSource(ctx, root, ex, src)
	switch {
	case err != nil:
		return "✗", err.Error()
	case r.ok():
		return "✗", m.VerifyOriginalPasses
	case !ex.Broken.match(r.Msgs, string(src)):
		return "✗", fmt.Sprintf(lings.M().VerifyWrongFailure, firstProblem(r.Msgs))
	}
	for _, b := range ex.Also {
		if !b.match(r.Msgs, string(src)) {
			return "✗", fmt.Sprintf(m.VerifyMissingFailure, b)
		}
	}
	return "✓", ""
}

// verifySolution checks that solutions/<Name>.lean passes and that an empty file does not.
func verifySolution(ctx context.Context, root string, ex Exercise) (mark, detail string) {
	src, err := os.ReadFile(filepath.Join(root, "solutions", ex.file()))
	if err != nil {
		return "✗", err.Error()
	}
	r, err := checkSource(ctx, root, ex, src)
	switch {
	case err != nil:
		return "✗", err.Error()
	case !r.ok():
		return "✗", r.Problem + "\n" + render(r.Msgs, "solutions/"+ex.file(), nil)
	}
	empty, err := checkSource(ctx, root, ex, nil)
	switch {
	case err != nil:
		return "✗", err.Error()
	case empty.ok():
		return "✗", m.VerifyEmptyPasses
	}
	return "✓", ""
}
