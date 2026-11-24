package track

import (
	"os"
	"path/filepath"
	"regexp"
	"slices"
	"strings"
	"unicode"
)

// stripComments removes Lean comments from src: "-- ..." to the end of the line and
// "/- ... -/" blocks, which nest (doc comments "/-- -/" and "/-! -/" included).
// Line breaks are kept, so line i of the result is line i of src.
// With keepStrings false, string and character literals are emptied too ("" and ' ').
//
// Not handled, because exercises do not need them: raw strings (r"...") and
// string literals inside the {} of interpolated strings (s!"{"a"}").
func stripComments(src string, keepStrings bool) string {
	rs := []rune(src)
	at := func(i int) rune {
		if i < len(rs) {
			return rs[i]
		}
		return 0
	}
	var out strings.Builder
	depth := 0 // block comments nest
	for i := 0; i < len(rs); i++ {
		c, next := rs[i], at(i+1)
		switch {
		case depth > 0:
			switch {
			case c == '/' && next == '-':
				depth++
				i++
			case c == '-' && next == '/':
				depth--
				i++
			case c == '\n':
				out.WriteRune('\n')
			}
		case c == '"':
			j := i + 1
			for ; j < len(rs) && rs[j] != '"'; j++ {
				if rs[j] == '\\' {
					j++
				}
			}
			lit := string(rs[i:min(j+1, len(rs))])
			if !keepStrings {
				lit = `""` + strings.Repeat("\n", strings.Count(lit, "\n"))
			}
			out.WriteString(lit)
			i = j
		case c == '\'' && charLiteralEnd(rs, i) > 0:
			j := charLiteralEnd(rs, i)
			if keepStrings {
				out.WriteString(string(rs[i : j+1]))
			} else {
				out.WriteString("' '")
			}
			i = j
		case c == '/' && next == '-':
			depth++
			i++
		case c == '-' && next == '-':
			for i+1 < len(rs) && rs[i+1] != '\n' {
				i++
			}
		default:
			out.WriteRune(c)
		}
	}
	return out.String()
}

// charLiteralEnd returns the index of the closing ' of a character literal
// starting at rs[i], or 0 if rs[i] does not start one. A ' right after an
// identifier is part of the identifier (x', h'), not a literal.
func charLiteralEnd(rs []rune, i int) int {
	if i > 0 && isIdentRune(rs[i-1]) {
		return 0
	}
	switch {
	case i+2 < len(rs) && rs[i+1] == '\\':
		for j := i + 2; j < len(rs) && j < i+12; j++ { // '\n', '\x41', '\u{1F600}'
			if rs[j] == '\'' && j > i+2 {
				return j
			}
		}
	case i+2 < len(rs) && rs[i+1] != '\'' && rs[i+1] != '\n' && rs[i+2] == '\'':
		return i + 2
	}
	return 0
}

func isIdentRune(r rune) bool {
	return unicode.IsLetter(r) || unicode.IsDigit(r) || r == '_' || r == '\'' || r == '!' || r == '?' ||
		(r >= '₀' && r <= '₉')
}

// codeLines returns the non-blank lines of src without comments.
// Indentation is significant in Lean, so only trailing whitespace is removed.
func codeLines(src string) []string {
	var lines []string
	for line := range strings.Lines(stripComments(src, true)) {
		if line = strings.TrimRight(line, " \t\r\n"); strings.TrimSpace(line) != "" {
			lines = append(lines, line)
		}
	}
	return lines
}

var (
	reGuard     = regexp.MustCompile(`^#guard(_expr)?\s`)
	reGuardMsgs = regexp.MustCompile(`(?m)^\s*#guard_msgs\b`)
)

// guardLines returns the #guard commands in the code of src.
// Each must fit on one line; -verify does not accept multi-line ones.
func guardLines(src string) []string {
	var out []string
	for _, l := range codeLines(src) {
		if l = strings.TrimSpace(l); reGuard.MatchString(l) {
			out = append(out, l)
		}
	}
	return out
}

// missingGuards returns the #guard lines of orig that work no longer contains, ignoring whitespace.
// Learners may add #guards of their own, but not remove or change the original ones:
// they are the tests of the exercise, and removing them would make it pass.
// A sorry in an original #guard is a blank to fill in, so it matches anything
// (#guard 7 / 2 == sorry matches #guard 7 / 2 == 3), as ??? does in tlings.
func missingGuards(orig, work string) []string {
	var have []string
	for _, l := range guardLines(work) {
		have = append(have, squeeze(l))
	}
	var missing []string
	for _, l := range guardLines(orig) {
		if !slices.ContainsFunc(have, guardPattern(l).MatchString) {
			missing = append(missing, l)
		}
	}
	return missing
}

// guardPattern matches the squeezed line l, with each sorry matching any non-empty text.
func guardPattern(l string) *regexp.Regexp {
	parts := reSorry.Split(l, -1)
	for i, p := range parts {
		parts[i] = regexp.QuoteMeta(squeeze(p))
	}
	return regexp.MustCompile("^" + strings.Join(parts, ".+") + "$")
}

var reSorry = regexp.MustCompile(`\bsorry\b`)

func squeeze(s string) string {
	return strings.Join(strings.Fields(s), "")
}

var reToken = regexp.MustCompile(`[\p{L}\p{N}_'.!?]+`)

// forbidden returns the words of forbid that the code of src uses (outside comments and strings).
// A word also matches with a trailing ? or ! (simp?, decide!) and as the last part of a
// dotted name, so that forbidding length also forbids List.length and xs.length.
// A word that ends with ? matches only itself: forbidding exact? leaves exact allowed.
func forbidden(src string, forbid []string) []string {
	if len(forbid) == 0 {
		return nil
	}
	tokens := reToken.FindAllString(stripComments(src, false), -1)
	matches := func(w string) func(string) bool {
		return func(t string) bool {
			for _, c := range []string{t, strings.TrimRight(t, "?!")} {
				if c == w || strings.HasSuffix(c, "."+w) {
					return true
				}
			}
			return false
		}
	}
	var used []string
	for _, w := range forbid {
		if slices.ContainsFunc(tokens, matches(w)) {
			used = append(used, w)
		}
	}
	return used
}

// referenceSource returns the source the reference is compiled from: the original
// exercise without comments and without # commands (#guard, #eval, #check, ...),
// which do not declare anything and fail while the original still has sorry.
// Line breaks are kept. Each # command must fit on one line.
func referenceSource(orig string) string {
	lines := strings.Split(stripComments(orig, true), "\n")
	for i, l := range lines {
		if strings.HasPrefix(strings.TrimSpace(l), "#") {
			lines[i] = ""
		}
	}
	return strings.Join(lines, "\n")
}

// readOriginal returns the original of ex in lang.
func readOriginal(root, lang string, ex Exercise) (string, error) {
	b, err := os.ReadFile(filepath.Join(root, "exercises", lang, ex.file()))
	return string(b), err
}

// lineOf returns the 1-based number of the first line of src whose code contains snippet, or 0.
// Comments do not count: explanations often show code like the snippet.
func lineOf(src, snippet string) int {
	for i, line := range strings.Split(stripComments(src, true), "\n") {
		if strings.Contains(line, snippet) {
			return i + 1
		}
	}
	return 0
}
