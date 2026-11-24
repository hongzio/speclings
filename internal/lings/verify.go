package lings

import (
	"context"
	"fmt"
	"path/filepath"
	"strings"
	"sync"
)

// runVerify checks the following for every exercise of t. It never looks at the learner's work/.
//
//   - The toolchain (t.VerifySetup).
//
// For every exercise:
//
//  1. In every language, the original fails in the intended way (t.VerifyOriginal).
//  2. Each translation has the same code as en (t.CodeLines). A missing translation is only a warning.
//  3. The solution passes (t.VerifySolution).
//
// It returns 1 if anything fails.
func runVerify(ctx context.Context, root string, t Track) int {
	setupOK := t.VerifySetup(ctx)

	langs := []string{BaseLang}
	for _, l := range Languages() {
		if l != BaseLang {
			langs = append(langs, l)
		}
	}

	type cell struct {
		mark   string // ✓ ✗ –
		detail string
	}
	exs := t.Exercises()
	rows := make([][]cell, len(exs)) // languages, then the solution
	sem := make(chan struct{}, 4)    // each check starts a JVM or a few Lean processes, so limit concurrency
	var wg sync.WaitGroup
	for i := range exs {
		rows[i] = make([]cell, len(langs)+1)
		for j, lang := range langs {
			wg.Go(func() {
				sem <- struct{}{}
				defer func() { <-sem }()
				mark, detail := verifyOriginal(ctx, root, t, i, lang)
				rows[i][j] = cell{mark, detail}
			})
		}
		wg.Go(func() {
			sem <- struct{}{}
			defer func() { <-sem }()
			mark, detail := t.VerifySolution(ctx, i)
			rows[i][len(langs)] = cell{mark, detail}
		})
	}
	wg.Wait()

	width := 0
	for _, ex := range exs {
		width = max(width, len(ex.Name))
	}
	failed := 0
	translated := make(map[string]int)
	for i, ex := range exs {
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
		mark := Green("✓")
		if !ok {
			mark, failed = Red("✗"), failed+1
		}
		fmt.Printf("%s %-*s %s\n", mark, width, ex.Name, strings.Join(line, "  "))
		for _, d := range details {
			fmt.Println(Dim(d))
		}
	}
	fmt.Println()
	for _, lang := range langs[1:] {
		fmt.Printf(m.VerifyCoverage+"\n", lang, translated[lang], len(exs))
	}
	if failed > 0 || !setupOK {
		fmt.Printf(m.VerifyFailed+"\n", failed, len(exs))
		return 1
	}
	fmt.Printf(m.VerifyAllOK+"\n", len(exs))
	return 0
}

// verifyOriginal checks that the original of exercise i in lang exists, has the same code
// as en, and (asking the track) fails in the intended way.
func verifyOriginal(ctx context.Context, root string, t Track, i int, lang string) (mark, detail string) {
	ex := t.Exercises()[i]
	dir := filepath.Join(root, t.ID(), "exercises", lang)
	if !IsFile(filepath.Join(dir, ex.Files[0])) {
		return "–", m.VerifyMissing
	}
	if lang != BaseLang {
		base := filepath.Join(root, t.ID(), "exercises", BaseLang)
		for _, f := range ex.Files {
			if diff := codeDiff(t.CodeLines, filepath.Join(base, f), filepath.Join(dir, f)); diff != "" {
				return "✗", fmt.Sprintf(m.VerifyCodeDiffers, f+" "+diff)
			}
		}
	}
	return t.VerifyOriginal(ctx, i, lang)
}
