package track

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/hongzio/speclings/internal/lings"
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
	if err := lings.CheckManifest("..", view); err != nil {
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

func TestTrimOutput(t *testing.T) {
	var trace strings.Builder
	trace.WriteString("libc++abi: terminating due to uncaught exception of type lean::throwable: deep recursion was detected at 'interpreter'\n")
	trace.WriteString("interpreter stacktrace:\n")
	for i := 1; i <= 1000; i++ {
		fmt.Fprintf(&trace, "#%d sumTo\n", i)
	}
	trace.WriteString("\n")
	got := trimOutput(trace.String())
	lines := strings.Split(strings.TrimSuffix(got, "\n"), "\n")
	if len(lines) != 2+keepFrames+2 {
		t.Fatalf("%d lines:\n%s", len(lines), got)
	}
	if lines[2+keepFrames-1] != fmt.Sprintf("#%d sumTo", keepFrames) || lines[2+keepFrames] != fmt.Sprintf(m.MoreFrames, 1000-keepFrames) {
		t.Errorf("frames not cut after %d:\n%s", keepFrames, got)
	}
	if !isDeepRecursion(got) {
		t.Error("the trimmed output no longer says what happened")
	}

	long := strings.Repeat("x\n", 200)
	if got := trimOutput(long); strings.Count(got, "\n") != maxLines+1 || !strings.HasSuffix(got, fmt.Sprintf(m.MoreLines, 200-maxLines)+"\n") {
		t.Errorf("long output not cut at %d lines: %d lines", maxLines, strings.Count(got, "\n"))
	}
	for _, s := range []string{"", "one line\n", "no newline", "#1 not a frame without a stack trace\n"} {
		if got := trimOutput(s); got != s {
			t.Errorf("trimOutput(%q) = %q", s, got)
		}
	}
}

func TestCrashOf(t *testing.T) {
	if got := crashOf("libc++abi: ... deep recursion was detected at 'interpreter' ...", nil); got != crashRecursion {
		t.Errorf("deep recursion: %q", got)
	}
	if got := crashOf("", nil); got != "" {
		t.Errorf("no crash: %q", got)
	}
}

// Every former name maps to a current exercise: a typo would silently drop a learner's progress.
func TestRenamed(t *testing.T) {
	names := map[string]bool{}
	for _, ex := range exercises {
		names[ex.Name] = true
	}
	for old, cur := range renamed {
		if !names[cur] {
			t.Errorf("renamed[%q] = %q, which is not an exercise", old, cur)
		}
	}
}
