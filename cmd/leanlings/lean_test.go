package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// testdata/<name>.jsonl is real `lean --json` output (Lean 4.36.0) for testdata/<name>.lean
// compiled as Exercise.lean, and <name>.plain is plain `lean` output for the same file.
func loadMsgs(t *testing.T, name string) ([]Message, string) {
	t.Helper()
	b, err := os.ReadFile(filepath.Join("testdata", name+".jsonl"))
	if err != nil {
		t.Fatal(err)
	}
	src, err := os.ReadFile(filepath.Join("testdata", name+".lean"))
	if err != nil {
		t.Fatal(err)
	}
	msgs, other := parseMessages(string(b))
	if other != "" {
		t.Fatalf("%s: unexpected non-message output %q", name, other)
	}
	return msgs, string(src)
}

func TestParseMessages(t *testing.T) {
	tests := []struct {
		name            string
		errors, warning int
		kinds           []string
	}{
		{"named", 1, 0, []string{"lean.unknownIdentifier", "", ""}},
		{"type", 1, 0, []string{""}},
		{"unsolved", 1, 0, []string{"Tactic.unsolvedGoals"}},
		{"sorry", 0, 2, []string{kindSorry, kindSorry, ""}},
		{"guard", 1, 0, []string{""}},
	}
	for _, tt := range tests {
		msgs, _ := loadMsgs(t, tt.name)
		c := Compiled{Msgs: msgs}
		if c.count(sevError) != tt.errors || c.count(sevWarning) != tt.warning {
			t.Errorf("%s: %d errors, %d warnings; want %d, %d", tt.name, c.count(sevError), c.count(sevWarning), tt.errors, tt.warning)
		}
		var kinds []string
		for _, msg := range msgs {
			kinds = append(kinds, msg.kindName())
		}
		if strings.Join(kinds, ",") != strings.Join(tt.kinds, ",") {
			t.Errorf("%s: kinds %q, want %q", tt.name, kinds, tt.kinds)
		}
	}
}

// render must reproduce what plain lean prints, so that learners see Lean's own output.
func TestRenderMatchesLean(t *testing.T) {
	for _, name := range []string{"named", "type", "unsolved", "sorry", "guard"} {
		msgs, _ := loadMsgs(t, name)
		want, err := os.ReadFile(filepath.Join("testdata", name+".plain"))
		if err != nil {
			t.Fatal(err)
		}
		if got := render(msgs, "Exercise.lean", nil); got != string(want) {
			t.Errorf("%s:\n got %q\nwant %q", name, got, want)
		}
	}
}

func TestBrokenMatch(t *testing.T) {
	typeMsgs, typeSrc := loadMsgs(t, "type") // "def f (n : Nat) : String := n" on line 1
	sorryMsgs, sorrySrc := loadMsgs(t, "sorry")
	namedMsgs, namedSrc := loadMsgs(t, "named")
	shifted := "-- a comment\n" + typeSrc
	tests := []struct {
		name string
		b    Broken
		msgs []Message
		src  string
		want bool
	}{
		{"intended", Broken{Contains: "Type mismatch"}, typeMsgs, typeSrc, true},
		{"intended at line", Broken{Contains: "Type mismatch", At: "def f"}, typeMsgs, typeSrc, true},
		{"snippet on another line", Broken{Contains: "Type mismatch", At: "def f"}, typeMsgs, shifted, false},
		{"snippet missing", Broken{Contains: "Type mismatch", At: "def g"}, typeMsgs, typeSrc, false},
		{"different error", Broken{Contains: "unexpected token"}, typeMsgs, typeSrc, false},
		{"warning wanted", Broken{Severity: sevWarning, Contains: "Type mismatch"}, typeMsgs, typeSrc, false},
		{"sorry in def", blank("def sum"), sorryMsgs, sorrySrc, true},
		{"sorry in theorem", blank("theorem t"), sorryMsgs, sorrySrc, true},
		{"sorry elsewhere", blank("#print"), sorryMsgs, sorrySrc, false},
		{"no sorry", blank("def f"), typeMsgs, typeSrc, false},
		{"named kind", Broken{Kind: "lean.unknownIdentifier", At: "def x"}, namedMsgs, namedSrc, true},
		{"other kind", Broken{Kind: "Tactic.unsolvedGoals"}, namedMsgs, namedSrc, false},
	}
	for _, tt := range tests {
		if got := tt.b.match(tt.msgs, tt.src); got != tt.want {
			t.Errorf("%s: match = %v, want %v", tt.name, got, tt.want)
		}
	}
}

func TestOnlySorryErrors(t *testing.T) {
	guardMsgs, _ := loadMsgs(t, "guard") // a #guard that really fails
	if onlySorryErrors(guardMsgs) {
		t.Error("a failing #guard counted as caused by sorry")
	}
	sorryMsgs, _ := loadMsgs(t, "sorry")
	blocked := append(sorryMsgs, Message{Severity: sevError,
		Data: "cannot evaluate code because 'triple._redArg' uses 'sorry' and/or contains errors"})
	if !onlySorryErrors(blocked) {
		t.Error("#guard blocked by sorry not recognized")
	}
}

func TestManifest(t *testing.T) {
	seen := map[string]bool{}
	for _, ex := range exercises {
		if seen[ex.Name] {
			t.Errorf("duplicate exercise %s", ex.Name)
		}
		seen[ex.Name] = true
		if ex.Hint[baseLang] == "" {
			t.Errorf("%s: Hint[%s] must not be empty", ex.Name, baseLang)
		}
		if ex.Broken.Kind == "" && ex.Broken.Contains == "" {
			t.Errorf("%s: Broken needs a Kind or a Contains", ex.Name)
		}
	}
	if err := checkManifest(filepath.Join("..", "..", "lean")); err != nil {
		t.Error(err)
	}
}

func TestVersionFiles(t *testing.T) {
	root := filepath.Join("..", "..")
	tv, err := toolchainVersion(root)
	if err != nil {
		t.Fatal(err)
	}
	mv, err := miseVersion(root)
	if err != nil {
		t.Fatal(err)
	}
	if tv != mv {
		t.Errorf("lean-toolchain has %s, mise.toml has %s", tv, mv)
	}
}
