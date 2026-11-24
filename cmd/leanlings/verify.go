package main

import (
	"context"
	"errors"
	"fmt"
	"maps"
	"os"
	"path/filepath"
	"slices"
	"strings"
	"sync"
)

// runVerify checks the following. It never looks at the learner's work/.
//
//   - The lean on PATH, lean-toolchain and mise.toml agree on the Lean version.
//
// For every exercise:
//
//  1. In every language, the original fails in the intended way (Broken), and fails the check.
//  2. Each translation has the same code as en (ignoring comments and blank lines). A missing translation is only a warning.
//  3. The en original does not use #guard_msgs.
//  4. The solution (solutions/) passes the check, and an empty file does not.
//
// It returns 1 if anything fails.
func runVerify(ctx context.Context, root string) int {
	versionsOK := verifyVersions(ctx, root)

	langs := []string{baseLang}
	for _, l := range slices.Sorted(maps.Keys(catalogs)) {
		if l != baseLang {
			langs = append(langs, l)
		}
	}

	type cell struct {
		mark   string // ✓ ✗ –
		detail string
	}
	rows := make([][]cell, len(exercises)) // languages, then the solution
	sem := make(chan struct{}, 4)          // each check runs a few Lean processes of ~400 MB
	var wg sync.WaitGroup
	for i, ex := range exercises {
		rows[i] = make([]cell, len(langs)+1)
		for j, lang := range langs {
			wg.Go(func() {
				sem <- struct{}{}
				defer func() { <-sem }()
				mark, detail := verifyOriginal(ctx, root, ex, lang)
				rows[i][j] = cell{mark, detail}
			})
		}
		wg.Go(func() {
			sem <- struct{}{}
			defer func() { <-sem }()
			mark, detail := verifySolution(ctx, root, ex)
			rows[i][len(langs)] = cell{mark, detail}
		})
	}
	wg.Wait()

	width := 0
	for _, ex := range exercises {
		width = max(width, len(ex.Name))
	}
	failed := 0
	translated := make(map[string]int)
	for i, ex := range exercises {
		ok := true
		var line, details []string
		for j, c := range rows[i] {
			label := m.VerifySolution
			if j < len(langs) {
				label = langs[j]
				if c.mark != "–" {
					translated[label]++
				}
			}
			line = append(line, label+" "+c.mark)
			if c.mark == "✗" {
				ok = false
			}
			if c.detail != "" {
				details = append(details, fmt.Sprintf("    %s: %s", label, strings.ReplaceAll(c.detail, "\n", "\n      ")))
			}
		}
		mark := green("✓")
		if !ok {
			mark, failed = red("✗"), failed+1
		}
		fmt.Printf("%s %-*s %s\n", mark, width, ex.Name, strings.Join(line, "  "))
		for _, d := range details {
			fmt.Println(dim(d))
		}
	}
	fmt.Println()
	for _, lang := range langs[1:] {
		fmt.Printf(m.VerifyCoverage+"\n", lang, translated[lang], len(exercises))
	}
	if failed > 0 || !versionsOK {
		fmt.Printf(m.VerifyFailed+"\n", failed, len(exercises))
		return 1
	}
	fmt.Printf(m.VerifyAllOK+"\n", len(exercises))
	return 0
}

// verifyVersions reports whether lean --version, lean-toolchain and mise.toml name the same Lean.
func verifyVersions(ctx context.Context, root string) bool {
	lv, err1 := leanVersion(ctx)
	repo := filepath.Dir(root) // lean-toolchain and mise.toml are shared by the whole repository
	tv, err2 := toolchainVersion(repo)
	mv, err3 := miseVersion(repo)
	if err := errors.Join(err1, err2, err3); err != nil {
		fmt.Printf("%s %v\n", red("✗"), err)
		return false
	}
	if lv != tv || tv != mv {
		fmt.Printf("%s %s\n", red("✗"), fmt.Sprintf(m.VerifyVersions, lv, tv, mv))
		return false
	}
	fmt.Printf("%s Lean %s\n", green("✓"), lv)
	return true
}

// verifyOriginal checks that the original in lang fails in the intended way and has the same code as en.
func verifyOriginal(ctx context.Context, root string, ex Exercise, lang string) (mark, detail string) {
	path := filepath.Join(root, "exercises", lang, ex.file())
	if !isFile(path) {
		return "–", m.VerifyMissing
	}
	src, err := os.ReadFile(path)
	if err != nil {
		return "✗", err.Error()
	}
	if lang == baseLang {
		if reGuardMsgs.MatchString(stripComments(string(src), true)) {
			return "✗", m.VerifyGuardMsgs
		}
	} else if diff := codeDiff(filepath.Join(root, "exercises", baseLang, ex.file()), path); diff != "" {
		return "✗", fmt.Sprintf(m.VerifyCodeDiffers, diff)
	}
	if ex.Broken.At != "" && lineOf(string(src), ex.Broken.At) == 0 {
		return "✗", fmt.Sprintf(m.VerifyNoSnippet, ex.Broken.At)
	}
	r, err := checkSource(ctx, root, ex, src)
	switch {
	case err != nil:
		return "✗", err.Error()
	case r.ok():
		return "✗", m.VerifyOriginalPasses
	case !ex.Broken.match(r.Msgs, string(src)):
		return "✗", fmt.Sprintf(m.VerifyWrongFailure, firstProblem(r.Msgs))
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

// codeDiff describes the first difference between the code of two files, or returns "" if they match.
func codeDiff(base, translated string) string {
	b, err := os.ReadFile(base)
	if err != nil {
		return err.Error()
	}
	t, err := os.ReadFile(translated)
	if err != nil {
		return err.Error()
	}
	bc, tc := codeLines(string(b)), codeLines(string(t))
	for i := range max(len(bc), len(tc)) {
		var x, y string
		if i < len(bc) {
			x = bc[i]
		}
		if i < len(tc) {
			y = tc[i]
		}
		if x != y {
			return fmt.Sprintf("%q ≠ %q", x, y)
		}
	}
	return ""
}
