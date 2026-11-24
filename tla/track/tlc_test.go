package track

import (
	"context"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/hongzio/speclings/internal/lings"
)

// testdata/*.out is real TLC 1.8.0 output (local paths replaced).
func load(t *testing.T, name string, exit int) Result {
	t.Helper()
	b, err := os.ReadFile(filepath.Join("testdata", name+".out"))
	if err != nil {
		t.Fatal(err)
	}
	return parseResult(exit, string(b))
}

func TestParseResult(t *testing.T) {
	tests := []struct {
		file     string
		exit     int
		distinct int
		violated string
		traceLen int
	}{
		{"holds", exitOK, 10000, "", 0},
		{"violates", exitSafety, 16, "Small", 6},
		{"deadlock", exitDeadlock, 4, "", 4},
		{"assume", exitAssume, -1, "", 0},
		{"parse", exitParse, -1, "", 0},
		{"temporal", exitProperty, 5, "EventuallyDone", 5},
		{"action", exitProperty, 3, "NeverBackwards", 3},
	}
	for _, tt := range tests {
		r := load(t, tt.file, tt.exit)
		if r.Distinct != tt.distinct || r.Violated != tt.violated || r.TraceLen != tt.traceLen {
			t.Errorf("%s: got distinct=%d violated=%q traceLen=%d, want %d %q %d",
				tt.file, r.Distinct, r.Violated, r.TraceLen, tt.distinct, tt.violated, tt.traceLen)
		}
	}
}

func TestParseRefinementViolation(t *testing.T) {
	out := "Error: Action property line 10, col 17 to line 10, col 29 of module 050_AtomicCounter is violated.\n"
	want := "line 10, col 17 to line 10, col 29 of module 050_AtomicCounter"
	if r := parseResult(exitProperty, out); r.Violated != want {
		t.Errorf("Violated = %q, want %q", r.Violated, want)
	}
}

func TestParseDistinctWithCommas(t *testing.T) {
	r := parseResult(0, "1,234 states generated, 1,000 distinct states found, 0 states left on queue.")
	if r.Distinct != 1000 {
		t.Errorf("distinct = %d, want 1000", r.Distinct)
	}
}

func TestJudge(t *testing.T) {
	tests := []struct {
		name   string
		expect Expect
		file   string
		exit   int
		ok     bool
		why    string // phrase why must contain when ok is false (en)
	}{
		{"holds", holds(10000), "holds", exitOK, true, ""},
		{"vacuous", holds(9999), "holds", exitOK, false, "found 10000 distinct states"},
		{"violates", violates("Small", 6), "violates", exitSafety, true, ""},
		{"wrong invariant", violates("TypeOK", 6), "violates", exitSafety, false, "should be violated is TypeOK"},
		{"property", violatesProperty("EventuallyDone"), "temporal", exitProperty, true, ""},
		{"action property", violatesProperty("NeverBackwards"), "action", exitProperty, true, ""},
		{"wrong property", violatesProperty("Other"), "temporal", exitProperty, false, "should be violated is Other"},
		{"property expected, invariant violated", violatesProperty("Small"), "violates", exitSafety, false, "invariant Small"},
		{"unexpected property violation", holds(5), "temporal", exitProperty, false, "property EventuallyDone is violated"},
		{"wrong trace", violates("Small", 5), "violates", exitSafety, false, "counterexample length is 6"},
		{"expected violation, got none", violates("Small", 6), "holds", exitOK, false, "no errors"},
		{"deadlocks", deadlocks(4), "deadlock", exitDeadlock, true, ""},
		{"unexpected deadlock", holds(4), "deadlock", exitDeadlock, false, "deadlock"},
		{"assume false", constant(), "assume", exitAssume, false, "ASSUME"},
		{"parse error", constant(), "parse", exitParse, false, "SANY"},
	}
	for _, tt := range tests {
		ok, why := judge(tt.expect, load(t, tt.file, tt.exit))
		if ok != tt.ok || !strings.Contains(why, tt.why) {
			t.Errorf("%s: judge = (%v, %q), want (%v, ...%q...)", tt.name, ok, why, tt.ok, tt.why)
		}
	}
}

func TestBrokenMatch(t *testing.T) {
	r := load(t, "parse", exitParse) // output for a module with "Two == 1 + 1" on line 2
	src := "---- MODULE 002_extends ----\nTwo == 1 + 1\n====\n"
	shifted := "---- MODULE 002_extends ----\n\\* comment\nTwo == 1 + 1\n====\n"
	tests := []struct {
		name string
		b    Broken
		src  string
		want bool
	}{
		{"intended", Broken{Exit: exitParse, Contains: "symbol '+'"}, src, true},
		{"intended at line", Broken{Exit: exitParse, Contains: "symbol '+'", At: "Two == 1 + 1"}, src, true},
		{"snippet on another line", Broken{Exit: exitParse, Contains: "symbol '+'", At: "Two == 1 + 1"}, shifted, false},
		{"snippet missing", Broken{Exit: exitParse, Contains: "symbol '+'", At: "Three"}, src, false},
		{"different error", Broken{Exit: exitParse, Contains: "does not match the name"}, src, false},
		{"different exit", Broken{Exit: exitAssume, Contains: "symbol '+'"}, src, false},
	}
	for _, tt := range tests {
		if got := tt.b.match(r, tt.src); got != tt.want {
			t.Errorf("%s: match = %v, want %v", tt.name, got, tt.want)
		}
	}
}

func TestManifest(t *testing.T) {
	if err := lings.CheckManifest("..", view); err != nil {
		t.Error(err)
	}
}

func TestManifestNames(t *testing.T) {
	seen := map[string]bool{}
	for _, ex := range exercises {
		if seen[ex.Name] {
			t.Errorf("duplicate exercise %s", ex.Name)
		}
		seen[ex.Name] = true
		if ex.Hint[baseLang] == "" || ex.Broken.Contains == "" {
			t.Errorf("%s: Hint[%s] and Broken.Contains must not be empty", ex.Name, baseLang)
		}
	}
}

// TestRunTLCTimeout runs real TLC on an infinite state space and checks that it is stopped.
func TestRunTLCTimeout(t *testing.T) {
	if _, err := exec.LookPath("tlc"); err != nil {
		t.Skip("tlc not on PATH (run inside mise)")
	}
	dir := t.TempDir()
	spec := "---- MODULE Inf ----\nEXTENDS Naturals\nVARIABLE n\nInit == n = 0\nNext == n' = n + 1\n====\n"
	if err := os.WriteFile(filepath.Join(dir, "Inf.tla"), []byte(spec), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "Inf.cfg"), []byte("INIT Init\nNEXT Next\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	start := time.Now()
	r, err := runTLCWithin(context.Background(), dir, "Inf", 3*time.Second)
	if err != nil {
		t.Fatal(err)
	}
	if r.Exit != exitTimeout || !strings.Contains(r.Output, "Computing initial states") {
		t.Errorf("exit = %d, output:\n%s", r.Exit, r.Output)
	}
	if d := time.Since(start); d > 6*time.Second {
		t.Errorf("took %s; TLC was not stopped promptly", d)
	}
}
