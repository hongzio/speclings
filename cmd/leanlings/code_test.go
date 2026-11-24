package main

import (
	"os"
	"path/filepath"
	"slices"
	"strings"
	"testing"
)

func TestCodeLines(t *testing.T) {
	src := `-- leanlings 000
def s := "a -- not a comment" -- but this is
/- block
   /- nested -/ still comment
-/
def c := '"' -- a quote character, then a comment
def x' := x'' -- primes are part of names, not char literals
/-- doc comment -/
theorem t : True := by
  trivial /- inline -/
`
	want := []string{
		`def s := "a -- not a comment"`,
		`def c := '"'`,
		`def x' := x''`,
		"theorem t : True := by",
		"  trivial",
	}
	if got := codeLines(src); !slices.Equal(got, want) {
		t.Errorf("codeLines =\n%q\nwant\n%q", got, want)
	}
}

func TestStripCommentsKeepsLines(t *testing.T) {
	src := "a /- x\ny -/ b\nc -- z\n\"s\ntr\" d\n"
	for _, keep := range []bool{true, false} {
		if got := stripComments(src, keep); strings.Count(got, "\n") != strings.Count(src, "\n") {
			t.Errorf("keepStrings=%v: %q has a different number of lines", keep, got)
		}
	}
	if got := stripComments(`f "omega" 'x' -- omega`, false); strings.Contains(got, "omega") || strings.Contains(got, "x") {
		t.Errorf("strings not emptied: %q", got)
	}
}

// Translations differ only in comments, so their code must be equal.
func TestCodeLinesIgnoresCommentLanguage(t *testing.T) {
	root := filepath.Join("..", "..")
	for _, ex := range exercises {
		ko := filepath.Join(root, "exercises", "ko", ex.file())
		if !isFile(ko) {
			continue
		}
		if diff := codeDiff(filepath.Join(root, "exercises", baseLang, ex.file()), ko); diff != "" {
			t.Errorf("%s: %s", ex.Name, diff)
		}
	}
	en := "-- The answer\ndef answer : Nat := 42\n"
	ko := "-- 답\n-- 입니다\ndef answer : Nat := 42\n"
	if !slices.Equal(codeLines(en), codeLines(ko)) {
		t.Errorf("same code, different comments: %q vs %q", codeLines(en), codeLines(ko))
	}
	if slices.Equal(codeLines(en), codeLines("def answer : Nat := 43\n")) {
		t.Error("different code reported as equal")
	}
}

func TestMissingGuards(t *testing.T) {
	orig := "-- #guard in a comment is ignored\ndef f (n : Nat) : Nat := sorry\n#guard f 1 == 2\n#guard f 0 == 0\n"
	tests := []struct {
		name, work string
		missing    int
	}{
		{"kept", "def f (n : Nat) : Nat := 2 * n\n#guard f 1 == 2\n#guard f 0 == 0\n", 0},
		{"whitespace differs", "#guard  f 1==2\n  #guard f 0 == 0\n", 0},
		{"one added", "#guard f 1 == 2\n#guard f 2 == 4\n#guard f 0 == 0\n", 0},
		{"commented out", "#guard f 1 == 2\n-- #guard f 0 == 0\n", 1},
		{"in a block comment", "/- #guard f 1 == 2 -/\n#guard f 0 == 0\n", 1},
		{"changed", "#guard f 1 == 3\n#guard f 0 == 0\n", 1},
		{"removed", "", 2},
	}
	for _, tt := range tests {
		if got := missingGuards(orig, tt.work); len(got) != tt.missing {
			t.Errorf("%s: missing = %q, want %d", tt.name, got, tt.missing)
		}
	}
}

// A sorry in an original #guard is a blank: anything may replace it, but the rest must stay.
func TestMissingGuardsBlanks(t *testing.T) {
	orig := "#guard 7 / 2 == sorry\n#guard (-7 : Int) / 2 == sorry\n#guard sorryCount == 0\n"
	tests := []struct {
		name, work string
		missing    int
	}{
		{"filled", "#guard 7 / 2 == 3\n#guard (-7 : Int) / 2 == -4\n#guard sorryCount == 0\n", 0},
		{"filled with an expression", "#guard 7/2 == (3 : Nat)\n#guard (-7 : Int) / 2 == -(4 : Int)\n#guard sorryCount == 0\n", 0},
		{"left side changed", "#guard 8 / 2 == 4\n#guard (-7 : Int) / 2 == -4\n#guard sorryCount == 0\n", 1},
		{"blank emptied", "#guard 7 / 2 ==\n#guard (-7 : Int) / 2 == -4\n#guard sorryCount == 0\n", 1},
		{"sorry inside a name is not a blank", "#guard 7 / 2 == 3\n#guard (-7 : Int) / 2 == -4\n#guard xCount == 0\n", 1},
	}
	for _, tt := range tests {
		if got := missingGuards(orig, tt.work); len(got) != tt.missing {
			t.Errorf("%s: missing = %q, want %d", tt.name, got, tt.missing)
		}
	}
}

func TestForbidden(t *testing.T) {
	forbid := []string{"omega", "simp", "decide"}
	tests := []struct {
		src  string
		want []string
	}{
		{"theorem t : 1 + 1 = 2 := by omega", []string{"omega"}},
		{"by simp? -- then decide", []string{"simp"}},
		{"by simp_all", nil}, // a different tactic; list it separately to forbid it
		{"-- no omega here\n/- nor simp -/\ndef s := \"decide\"", nil},
		{"exact Nat.decide_eq_true h", nil},
		{"by decide", []string{"decide"}},
	}
	for _, tt := range tests {
		if got := forbidden(tt.src, forbid); !slices.Equal(got, tt.want) {
			t.Errorf("forbidden(%q) = %q, want %q", tt.src, got, tt.want)
		}
	}

	// A word with ? forbids only the search tactic, not the tactic it suggests.
	search := []string{"exact?", "simp"}
	for src, want := range map[string][]string{
		"by exact h":          nil,
		"by exact?":           {"exact?"},
		"by simp?":            {"simp"},
		"by apply h; exact? ": {"exact?"},
	} {
		if got := forbidden(src, search); !slices.Equal(got, want) {
			t.Errorf("forbidden(%q) = %q, want %q", src, got, want)
		}
	}

	// Library functions are forbidden however they are called.
	lib := []string{"length", "sum"}
	for src, want := range map[string][]string{
		"def len (xs : List Nat) : Nat := xs.length":               {"length"},
		"def len (xs : List Nat) : Nat := List.length xs":          {"length"},
		"def total (xs : List Nat) := xs |>.sum":                   {"sum"},
		"def len : List Nat → Nat | [] => 0 | _ :: t => 1 + len t": nil,
		"def lengthy := 1\ndef summary := lengthy":                 nil,
	} {
		if got := forbidden(src, lib); !slices.Equal(got, want) {
			t.Errorf("forbidden(%q) = %q, want %q", src, got, want)
		}
	}
}

func TestReferenceSource(t *testing.T) {
	orig := "-- comment\ndef f : Nat := sorry\n#guard f == 1\n  #eval f\n/- #check in a comment -/\ntheorem t : f = f := rfl\n"
	got := referenceSource(orig)
	if strings.Count(got, "\n") != strings.Count(orig, "\n") {
		t.Errorf("line count changed: %q", got)
	}
	if strings.Contains(got, "#") || strings.Contains(got, "comment") {
		t.Errorf("# commands or comments left: %q", got)
	}
	if !strings.Contains(got, "def f : Nat := sorry") || !strings.Contains(got, "theorem t : f = f := rfl") {
		t.Errorf("declarations lost: %q", got)
	}
}

// Explanations show code like the snippet; Broken.At must find the code, not the comment.
func TestLineOfSkipsComments(t *testing.T) {
	src := "-- Write it like this:\n--   def swap {α β : Type} (p : α × β) := ...\ndef swap {α β : Type} (p : α × β) : β × α := sorry\n"
	if got := lineOf(src, "def swap"); got != 3 {
		t.Errorf("lineOf = %d, want 3", got)
	}
	if got := lineOf(src, "like this"); got != 0 {
		t.Errorf("a snippet only in a comment: lineOf = %d, want 0", got)
	}
}

func TestGuardMsgsDetected(t *testing.T) {
	for src, want := range map[string]bool{
		"/-- info: 2 -/\n#guard_msgs in\n#eval 1 + 1\n": true,
		"-- #guard_msgs is mentioned only here\n":       false,
	} {
		if got := reGuardMsgs.MatchString(stripComments(src, true)); got != want {
			t.Errorf("%q: %v, want %v", src, got, want)
		}
	}
}

func TestOriginalsReadable(t *testing.T) {
	root := filepath.Join("..", "..", "lean")
	for _, ex := range exercises {
		if _, err := os.Stat(filepath.Join(root, "solutions", ex.file())); err != nil {
			t.Errorf("%s: %v", ex.Name, err)
		}
	}
}
