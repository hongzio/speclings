package main

import (
	"context"
	"fmt"
	"maps"
	"os"
	"path/filepath"
	"slices"
	"strings"
	"sync"
)

// runVerify checks the following for every exercise. It never looks at the learner's work/.
//
//  1. In every language, the original fails in the intended way (Broken).
//  2. Each translation has the same code as en (ignoring comments and blank lines). A missing translation is only a warning.
//  3. The solution (solutions/) meets Expect.
//
// It returns 1 if anything fails.
func runVerify(ctx context.Context, root string) int {
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
	sem := make(chan struct{}, 4)          // each TLC run starts a JVM, so limit concurrency
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
				details = append(details, fmt.Sprintf("    %s: %s", label, c.detail))
			}
		}
		mark := green("✓")
		if !ok {
			mark, failed = red("✗"), failed+1
		}
		fmt.Printf("%s %-16s %s\n", mark, ex.Name, strings.Join(line, "  "))
		for _, d := range details {
			fmt.Println(dim(d))
		}
	}
	fmt.Println()
	for _, lang := range langs[1:] {
		fmt.Printf(m.VerifyCoverage+"\n", lang, translated[lang], len(exercises))
	}
	if failed > 0 {
		fmt.Printf(m.VerifyFailed+"\n", failed, len(exercises))
		return 1
	}
	fmt.Printf(m.VerifyAllOK+"\n", len(exercises))
	return 0
}

// verifyOriginal checks that the original in lang fails in the intended way and has the same code as en.
func verifyOriginal(ctx context.Context, root string, ex Exercise, lang string) (mark, detail string) {
	dir := filepath.Join(root, "exercises", lang)
	if !isFile(filepath.Join(dir, ex.Name+".tla")) {
		return "–", m.VerifyMissing
	}
	if lang != baseLang {
		for _, ext := range []string{".tla", ".cfg"} {
			if diff := codeDiff(filepath.Join(root, "exercises", baseLang, ex.Name+ext), filepath.Join(dir, ex.Name+ext)); diff != "" {
				return "✗", fmt.Sprintf(m.VerifyCodeDiffers, ex.Name+ext+" "+diff)
			}
		}
	}
	src, err := os.ReadFile(filepath.Join(dir, ex.Name+".tla"))
	if err != nil {
		return "✗", err.Error()
	}
	if ex.Broken.At != "" && lineOf(string(src), ex.Broken.At) == 0 {
		return "✗", fmt.Sprintf(m.VerifyNoSnippet, ex.Broken.At)
	}
	r, err := runTLC(ctx, dir, ex.Name)
	if err != nil {
		return "✗", err.Error()
	}
	if !ex.Broken.match(r, string(src)) {
		return "✗", fmt.Sprintf(m.VerifyWrongFailure, describe(r))
	}
	return "✓", ""
}

// verifySolution copies solutions/<Name>.tla to a temporary directory and checks it.
// It uses solutions/<Name>.cfg if present, otherwise the en original's .cfg.
func verifySolution(ctx context.Context, root string, ex Exercise) (mark, detail string) {
	tmp, err := os.MkdirTemp("", "tlings-sol-")
	if err != nil {
		return "✗", err.Error()
	}
	defer os.RemoveAll(tmp)

	cfg := filepath.Join(root, "solutions", ex.Name+".cfg")
	if !isFile(cfg) {
		cfg = filepath.Join(root, "exercises", baseLang, ex.Name+".cfg")
	}
	for src, dst := range map[string]string{
		filepath.Join(root, "solutions", ex.Name+".tla"): ex.Name + ".tla",
		cfg: ex.Name + ".cfg",
	} {
		if err := copyFile(src, filepath.Join(tmp, dst)); err != nil {
			return "✗", err.Error()
		}
	}
	r, err := runTLC(ctx, tmp, ex.Name)
	if err != nil {
		return "✗", err.Error()
	}
	if ok, why := judge(ex.Expect, r); !ok {
		return "✗", why
	}
	return "✓", ""
}

// codeDiff describes the first difference between the code of two files, or returns "" if they match.
// A missing translated file (e.g. an untranslated .cfg) counts as matching, since the English one is used.
func codeDiff(base, translated string) string {
	b, err := os.ReadFile(base)
	if err != nil {
		return err.Error()
	}
	t, err := os.ReadFile(translated)
	if err != nil {
		return ""
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

// codeLines strips comments from TLA+ source (.tla or .cfg) and returns the non-blank lines.
// Indentation is significant (alignment of /\ and \/ lists), so only trailing whitespace is removed.
func codeLines(src string) []string {
	var out strings.Builder
	depth := 0 // (* *) comments nest
	inString := false
	for i := 0; i < len(src); i++ {
		c := src[i]
		next := byte(0)
		if i+1 < len(src) {
			next = src[i+1]
		}
		switch {
		case depth > 0:
			if c == '(' && next == '*' {
				depth++
				i++
			} else if c == '*' && next == ')' {
				depth--
				i++
			} else if c == '\n' {
				out.WriteByte('\n') // keep line structure
			}
		case inString:
			out.WriteByte(c)
			if c == '\\' && next != 0 {
				out.WriteByte(next)
				i++
			} else if c == '"' {
				inString = false
			}
		case c == '"':
			inString = true
			out.WriteByte(c)
		case c == '(' && next == '*':
			depth++
			i++
		case c == '\\' && next == '*':
			for i < len(src) && src[i] != '\n' {
				i++
			}
			if i < len(src) {
				out.WriteByte('\n')
			}
		default:
			out.WriteByte(c)
		}
	}
	var lines []string
	for line := range strings.Lines(out.String()) {
		if line = strings.TrimRight(line, " \t\r\n"); strings.TrimSpace(line) != "" {
			lines = append(lines, line)
		}
	}
	return lines
}
