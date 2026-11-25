package track

import (
	"context"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"github.com/hongzio/speclings/internal/lings"
)

// The tests in this file run real Lean and the real checker. They are skipped
// unless lean is on PATH (run inside mise) and checker/ has been built (speclings lean does that).

const fillOriginal = `-- an exercise to fill in
def double (n : Nat) : Nat := n + n

def triple (n : Nat) : Nat := sorry

#guard triple 4 == 12

theorem double_two : double 2 = 4 := sorry

theorem triple_eq (n : Nat) : triple n = 3 * n := by
  sorry
`

const fillSolution = `def double (n : Nat) : Nat := n + n

def triple (n : Nat) : Nat := 3 * n

#guard triple 4 == 12

theorem double_two : double 2 = 4 := rfl

theorem triple_eq (n : Nat) : triple n = 3 * n := rfl
`

// testRoot returns a Lean track directory with exercises/en/X.lean set to orig, using the real checker.
func testRoot(t *testing.T, orig string) string {
	t.Helper()
	if _, err := exec.LookPath("lean"); err != nil {
		t.Skip("lean not on PATH (run inside mise)")
	}
	real, err := filepath.Abs("..") // lean/
	if err != nil {
		t.Fatal(err)
	}
	if !lings.IsFile(checkerPath(real)) {
		t.Skip("checker not built (run speclings lean once)")
	}
	root := t.TempDir()
	if err := os.Symlink(filepath.Join(real, "checker"), filepath.Join(root, "checker")); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(filepath.Join(root, "exercises", baseLang), 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(root, "exercises", baseLang, "X.lean"), []byte(orig), 0o644); err != nil {
		t.Fatal(err)
	}
	return root
}

func TestCheckFill(t *testing.T) {
	root := testRoot(t, fillOriginal)
	ex := Exercise{Name: "X", Expect: fill()}
	tests := []struct {
		name string
		src  string
		want string // a phrase of the problem; "" to pass
	}{
		{"solution", fillSolution, ""},
		{"helper lemma", strings.Replace(fillSolution, "theorem double_two : double 2 = 4 := rfl",
			"theorem helper : 2 + 2 = 4 := rfl\ntheorem double_two : double 2 = 4 := helper", 1), ""},
		{"original", fillOriginal, m.ProbSorryRun},
		{"one sorry left", strings.Replace(fillSolution, ":= rfl\n\ntheorem triple_eq", ":= sorry\n\ntheorem triple_eq", 1), m.ProbSorry},
		{"type error", strings.Replace(fillSolution, "3 * n\n\n#guard", `"three"`+"\n\n#guard", 1), "error(s)"},
		{"wrong triple", strings.Replace(fillSolution, "def triple (n : Nat) : Nat := 3 * n", "def triple (n : Nat) : Nat := 3 * n + 1", 1), "error(s)"},
		{"guard removed", strings.Replace(fillSolution, "#guard triple 4 == 12\n", "", 1), "#guard triple 4 == 12"},
		{"statement changed", strings.Replace(fillSolution, "double 2 = 4 := rfl", "True := trivial", 1), "statement of double_two"},
		{"given def changed", strings.Replace(fillSolution, "def double (n : Nat) : Nat := n + n", "def double (n : Nat) : Nat := 2 * n", 1), "definition double"},
		{"theorem removed", strings.Replace(fillSolution, "theorem double_two : double 2 = 4 := rfl\n", "", 1), "double_two was removed"},
		{"axiom", strings.Replace(fillSolution, "theorem double_two : double 2 = 4 := rfl",
			"axiom cheat : double 2 = 4\ntheorem double_two : double 2 = 4 := cheat", 1), "cheat"},
		{"native_decide", strings.Replace(fillSolution, "double 2 = 4 := rfl", "double 2 = 4 := by native_decide", 1), "_native"},
		{"theorem to axiom", strings.Replace(fillSolution, "theorem double_two : double 2 = 4 := rfl", "axiom double_two : double 2 = 4", 1), "changed kind"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			r, err := checkSource(context.Background(), root, ex, []byte(tt.src))
			if err != nil {
				t.Fatal(err)
			}
			switch {
			case tt.want == "" && !r.ok():
				t.Errorf("rejected: %s\n%s", r.Problem, render(r.Msgs, "X.lean", nil))
			case tt.want != "" && !strings.Contains(r.Problem, tt.want):
				t.Errorf("problem %q, want one containing %q", r.Problem, tt.want)
			}
		})
	}
}

func TestCheckForbidAndOutput(t *testing.T) {
	orig := "def main : IO Unit := sorry\n\ntheorem t : 2 + 2 = 4 := sorry\n"
	root := testRoot(t, orig)
	ex := Exercise{Name: "X", Expect: fill().prints("hi\n").without("decide")}
	tests := []struct {
		name, src, want string
	}{
		{"solution", "def main : IO Unit := IO.println \"hi\"\n\ntheorem t : 2 + 2 = 4 := rfl\n", ""},
		{"forbidden", "def main : IO Unit := IO.println \"hi\"\n\ntheorem t : 2 + 2 = 4 := by decide\n", "decide"},
		{"wrong output", "def main : IO Unit := IO.println \"ho\"\n\ntheorem t : 2 + 2 = 4 := rfl\n", "ho"},
		{"failing main", "def main : IO Unit := throw (IO.userError \"no\")\n\ntheorem t : 2 + 2 = 4 := rfl\n", "exit code 1"},
		{"failing main shows why", "def main : IO Unit := throw (IO.userError \"no\")\n\ntheorem t : 2 + 2 = 4 := rfl\n", "uncaught exception: no"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			r, err := checkSource(context.Background(), root, ex, []byte(tt.src))
			if err != nil {
				t.Fatal(err)
			}
			switch {
			case tt.want == "" && !r.ok():
				t.Errorf("rejected: %s", r.Problem)
			case tt.want != "" && !strings.Contains(r.Problem, tt.want):
				t.Errorf("problem %q, want one containing %q", r.Problem, tt.want)
			}
		})
	}
}

const debugOriginal = `-- an exercise to debug
def double (n : Nat) : Nat := n + n

theorem double_eq (n : Nat) : double n = 2 * n := by
  rw [double]

theorem swap (p q : Prop) (h : p ∧ q) : q ∧ p := by
  exact ⟨h.1, h.2⟩
`

const debugSolution = `def double (n : Nat) : Nat := n + n

theorem double_eq (n : Nat) : double n = 2 * n := by
  rw [double]; omega

theorem swap (p q : Prop) (h : p ∧ q) : q ∧ p := by
  exact ⟨h.2, h.1⟩
`

// A debug() original has errors on purpose, and its declarations are still the reference.
func TestCheckDebug(t *testing.T) {
	root := testRoot(t, debugOriginal)
	ex := Exercise{Name: "X", Expect: debug()}
	tests := []struct {
		name, src, want string // want: a phrase of the problem; "" to pass
	}{
		{"solution", debugSolution, ""},
		{"other proof", strings.Replace(debugSolution, "rw [double]; omega", "unfold double; omega", 1), ""},
		{"original", debugOriginal, "error(s)"},
		{"sorry", strings.Replace(debugSolution, "exact ⟨h.2, h.1⟩", "sorry", 1), m.ProbSorry},
		{"statement changed", strings.Replace(debugSolution, "q ∧ p := by\n  exact ⟨h.2, h.1⟩", "q := by\n  exact h.2", 1), "statement of swap"},
		{"given def changed", strings.Replace(debugSolution, ":= n + n", ":= n * 2", 1), "definition double"},
		{"theorem removed", debugSolution[:strings.Index(debugSolution, "theorem swap")], "swap was removed"},
		{"empty", "", "double was removed"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			r, err := checkSource(context.Background(), root, ex, []byte(tt.src))
			if err != nil {
				t.Fatal(err)
			}
			switch {
			case tt.want == "" && !r.ok():
				t.Errorf("rejected: %s\n%s", r.Problem, render(r.Msgs, "X.lean", nil))
			case tt.want != "" && !strings.Contains(r.Problem, tt.want):
				t.Errorf("problem %q, want one containing %q", r.Problem, tt.want)
			}
		})
	}

	// -verify checks every intended failure of the original, not only the first.
	ex.Broken = Broken{Contains: "unsolved goals", At: "theorem double_eq"}
	ex.Also = []Broken{{Contains: "Application type mismatch", At: "exact ⟨h.1, h.2⟩"}}
	if mark, detail := verifyOriginal(context.Background(), root, ex, baseLang); mark != "✓" {
		t.Errorf("verifyOriginal: %s %s", mark, detail)
	}
	ex.Also = append(ex.Also, Broken{Contains: "omega could not prove the goal", At: "rw [double]"})
	if mark, detail := verifyOriginal(context.Background(), root, ex, baseLang); mark != "✗" || !strings.Contains(detail, "omega could not") {
		t.Errorf("verifyOriginal with a failure that does not happen: %s %s", mark, detail)
	}
}

// A search tactic left in the file is rejected, with what it found and how to use it.
func TestCheckSearchTactic(t *testing.T) {
	root := testRoot(t, "theorem t (a b : Nat) (h : a < b) : a ≤ b := by\n  sorry\n")
	ex := Exercise{Name: "X", Expect: fill().without("exact?", "omega")}
	r, err := checkSource(context.Background(), root, ex, []byte("theorem t (a b : Nat) (h : a < b) : a ≤ b := by\n  exact?\n"))
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(r.Problem, "exact?") || !strings.Contains(r.Problem, m.ProbSearch) {
		t.Errorf("problem %q", r.Problem)
	}
	if shown := render(r.Msgs, "X.lean", nil); !strings.Contains(shown, "Try this") {
		t.Errorf("the suggestion is not shown:\n%s", shown)
	}
	r, err = checkSource(context.Background(), root, ex, []byte("theorem t (a b : Nat) (h : a < b) : a ≤ b := by\n  omega\n"))
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(r.Problem, "omega") || strings.Contains(r.Problem, m.ProbSearch) {
		t.Errorf("omega is forbidden, but not a search tactic: %q", r.Problem)
	}
}

// An original that does not compile apart from its sorrys cannot be a reference: that is a setup error.
func TestCheckBrokenReference(t *testing.T) {
	root := testRoot(t, "def f : Nat := \"x\"\n")
	_, err := checkSource(context.Background(), root, Exercise{Name: "X", Expect: fill()}, []byte("def f : Nat := 1\n"))
	if err == nil || !strings.Contains(err.Error(), "does not compile") {
		t.Errorf("err = %v", err)
	}
}

// A function that fails to show termination is still run by #guard, and recurses until Lean
// aborts with a stack trace of about 1.3 million lines (exercise 012). Running main does the
// same with a partial def. Both must give a short output and say what happened.
func TestCheckDeepRecursion(t *testing.T) {
	orig := "def sumTo : Nat → Nat\n  | 0 => 0\n  | n + 1 => (n + 1) + sumTo (n + 1)\n\n#guard sumTo 4 == 10\n"
	root := testRoot(t, orig)
	r, err := checkSource(context.Background(), root, Exercise{Name: "X", Expect: fix()}, []byte(orig))
	if err != nil {
		t.Fatal(err)
	}
	if r.Problem != m.ProbDeepRecursion {
		t.Errorf("problem %q", r.Problem)
	}
	if n := strings.Count(r.Other, "\n"); n > maxLines+1 || !strings.Contains(r.Other, "interpreter stacktrace:") {
		t.Errorf("Other has %d lines:\n%.2000s", n, r.Other)
	}
	if !strings.Contains(render(r.Msgs, "X.lean", nil), "fail to show termination") {
		t.Error("the termination error is missing")
	}

	loop := "partial def loop (n : Nat) : Nat := loop (n + 1) + 1\n\ndef main : IO Unit := IO.println (loop 3)\n"
	root = testRoot(t, loop)
	r, err = checkSource(context.Background(), root, Exercise{Name: "X", Expect: fix().prints("4\n")}, []byte(loop))
	if err != nil {
		t.Fatal(err)
	}
	if !strings.HasPrefix(r.Problem, m.ProbDeepRecursion) || !strings.Contains(r.Problem, "#1 loop") || strings.Count(r.Problem, "\n") > maxLines+5 {
		t.Errorf("main: problem of %d lines:\n%.2000s", strings.Count(r.Problem, "\n"), r.Problem)
	}
}
