package track

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"slices"
	"strings"
	"time"

	"github.com/hongzio/speclings/internal/lings"
)

// verifyOriginal checks that the original in lang fails in the intended way. The engine has
// already checked that it exists and that its code (and that of the .cfg and helper modules) matches en.
// root is the track's directory, tla/.
func verifyOriginal(ctx context.Context, root string, ex Exercise, lang string) (mark, detail string) {
	dir := filepath.Join(root, "exercises", lang)
	for _, mod := range ex.Modules {
		if !lings.IsFile(filepath.Join(dir, mod+".tla")) {
			return "✗", fmt.Sprintf(lings.M().VerifyCodeDiffers, mod+".tla: missing")
		}
	}
	src, err := os.ReadFile(filepath.Join(dir, ex.Name+".tla"))
	if err != nil {
		return "✗", err.Error()
	}
	if ex.Broken.At != "" && lineOf(string(src), ex.Broken.At) == 0 {
		return "✗", fmt.Sprintf(lings.M().VerifyNoSnippet, ex.Broken.At)
	}
	timeout := tlcTimeout
	if ex.Broken.Exit == exitTimeout {
		timeout = verifyTimeout
	}
	r, err := runTLCWithin(ctx, dir, ex.Name, timeout)
	if err != nil {
		return "✗", err.Error()
	}
	if !ex.Broken.match(r, string(src)) {
		return "✗", fmt.Sprintf(lings.M().VerifyWrongFailure, describe(r))
	}
	return "✓", ""
}

// verifyTimeout is how long -verify lets an original run that is expected to time out.
const verifyTimeout = 10 * time.Second

// verifySolution copies solutions/<Name>.tla to a temporary directory and checks it.
// It uses solutions/<Name>.cfg if present, otherwise the en original's .cfg, and the
// en originals of the helper modules.
func verifySolution(ctx context.Context, root string, ex Exercise) (mark, detail string) {
	tmp, err := os.MkdirTemp("", "speclings-tla-sol-")
	if err != nil {
		return "✗", err.Error()
	}
	defer os.RemoveAll(tmp)

	cfg := filepath.Join(root, "solutions", ex.Name+".cfg")
	if !lings.IsFile(cfg) {
		cfg = filepath.Join(root, "exercises", baseLang, ex.Name+".cfg")
	}
	copies := map[string]string{
		filepath.Join(root, "solutions", ex.Name+".tla"): ex.Name + ".tla",
		cfg: ex.Name + ".cfg",
	}
	for _, mod := range ex.Modules {
		copies[filepath.Join(root, "exercises", baseLang, mod+".tla")] = mod + ".tla"
	}
	for src, dst := range copies {
		if err := lings.CopyFile(src, filepath.Join(tmp, dst)); err != nil {
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
	if missing := missingAssumes(root, ex, filepath.Join(tmp, ex.Name+".tla")); len(missing) > 0 {
		return "✗", fmt.Sprintf(m.MissingAssume, strings.Join(missing, "; "))
	}
	return "✓", ""
}

// missingAssumes returns the ASSUME lines of ex's en original that file no longer contains.
// Whitespace is ignored and ??? in the original matches anything, so a learner may fill in
// blanks and add ASSUMEs of their own (such as PrintT), but not remove or change the
// original ones: in a module without variables, removing an ASSUME removes the check
// itself, and TLC would happily pass.
//
// The ASSUME line containing ex.Broken.At is the one the learner is meant to fix, so it
// only has to keep the At snippet. That lets an exercise ask for a value to be corrected.
func missingAssumes(root string, ex Exercise, file string) []string {
	orig, err := os.ReadFile(filepath.Join(root, "exercises", baseLang, ex.Name+".tla"))
	if err != nil {
		return nil
	}
	got, err := os.ReadFile(file)
	if err != nil {
		return nil
	}
	var have []string
	for _, l := range assumeLines(string(got)) {
		have = append(have, squeeze(l))
	}
	var missing []string
	for _, l := range assumeLines(string(orig)) {
		re := assumePattern(l, true)
		if ex.Broken.At != "" && strings.Contains(l, ex.Broken.At) {
			re = assumePattern(ex.Broken.At, false)
		}
		if !slices.ContainsFunc(have, re.MatchString) {
			missing = append(missing, l)
		}
	}
	return missing
}

// assumePattern matches s, ignoring whitespace, with each ??? matching anything.
// whole requires the entire line to match; otherwise s may appear anywhere in it.
func assumePattern(s string, whole bool) *regexp.Regexp {
	parts := strings.Split(squeeze(s), "???")
	for i, p := range parts {
		parts[i] = regexp.QuoteMeta(p)
	}
	re := strings.Join(parts, ".+")
	if whole {
		re = "^" + re + "$"
	}
	return regexp.MustCompile(re)
}

// assumeLines returns the lines of src's code (comments excluded) that start with ASSUME.
func assumeLines(src string) []string {
	var out []string
	for _, l := range codeLines(src) {
		if l = strings.TrimSpace(l); reAssume.MatchString(l) {
			out = append(out, l)
		}
	}
	return out
}

var reAssume = regexp.MustCompile(`^ASSUME\b`)

func squeeze(s string) string {
	return strings.Join(strings.Fields(s), "")
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
