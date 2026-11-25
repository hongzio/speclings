package track

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"github.com/hongzio/speclings/internal/lings"
)

// moduleName is the module every exercise is compiled as. speclings copies the file
// to be checked into a temporary directory as Exercise.lean, so that the learner's
// file and the reference compile to modules with the same name (the checker
// compares them declaration by declaration) and nothing is written to work/.
const moduleName = "Exercise"

// Timeouts for one Lean run. Exercises compile in well under a second, so a run
// that takes longer most likely has a recursion or a proof search that does not end.
const (
	leanTimeout = 30 * time.Second
	runTimeout  = 10 * time.Second
)

const (
	sevError   = "error"
	sevWarning = "warning"
	sevInfo    = "information"
	kindSorry  = "hasSorry" // "declaration uses `sorry`"
)

// Message is one message of `lean --json` (Lean's SerialMessage).
type Message struct {
	FileName string `json:"fileName"`
	Pos      Pos    `json:"pos"`
	Severity string `json:"severity"` // error, warning or information
	Kind     string `json:"kind"`     // e.g. hasSorry, Tactic.unsolvedGoals, lean.unknownIdentifier._namedError, [anonymous]
	Data     string `json:"data"`
}

// Pos is a position in the source: line is 1-based, column is 0-based (as Lean prints them).
type Pos struct {
	Line   int `json:"line"`
	Column int `json:"column"`
}

// kindName returns the message kind without Lean's "._namedError" suffix, or "" for an anonymous kind.
func (msg Message) kindName() string {
	k := strings.TrimSuffix(msg.Kind, "._namedError")
	if k == "[anonymous]" {
		return ""
	}
	return k
}

// Compiled is the result of compiling one file.
type Compiled struct {
	Msgs     []Message
	Other    string // output that is not a message (unusual), shortened by trimOutput
	TimedOut bool
	// Crash says why Lean stopped before the end of the file: crashRecursion, how the
	// process ended, or "" if it did not stop early. Msgs then lack the rest of the file.
	Crash string
}

// crashRecursion is the Crash of a #guard or #eval whose code recursed too deeply,
// typically a function that fails to show termination: Lean reports the error, but
// still runs the function.
const crashRecursion = "deep recursion"

// crashOf tells from Lean's stderr and exit why it stopped early, or returns "".
func crashOf(stderr string, ee *exec.ExitError) string {
	switch {
	case isDeepRecursion(stderr):
		return crashRecursion
	case ee != nil && ee.ExitCode() == -1: // killed by a signal, e.g. an abort
		return ee.Error()
	}
	return ""
}

// isDeepRecursion reports whether out is Lean's report of a recursion that went too deep.
// Compiling, Lean aborts with it; running main (lean --run), it exits with code 1.
func isDeepRecursion(out string) bool {
	return strings.Contains(out, "deep recursion was detected")
}

// Limits of trimOutput.
const (
	keepFrames = 10 // of an interpreter stack trace
	maxLines   = 50 // in all
)

// trimOutput shortens what Lean printed besides its messages. When running code recurses
// too deeply, Lean's interpreter prints its stack, a line per call: about 1.3 million lines
// (18 MB, tens of seconds in a terminal) for a recursion that never ends. trimOutput keeps
// the first keepFrames frames of each stack trace, and at most maxLines lines in all.
func trimOutput(s string) string {
	var out []string
	inTrace, frames, skipped := false, 0, 0
	flush := func() {
		if skipped > 0 {
			out = append(out, fmt.Sprintf(m.MoreFrames, skipped)+"\n")
			skipped = 0
		}
	}
	for l := range strings.Lines(s) {
		switch {
		case strings.HasPrefix(l, "interpreter stacktrace:"):
			flush()
			inTrace, frames = true, 0
			out = append(out, l)
		case inTrace && strings.HasPrefix(l, "#"):
			if frames++; frames <= keepFrames {
				out = append(out, l)
			} else {
				skipped++
			}
		default:
			inTrace = false
			flush()
			out = append(out, l)
		}
	}
	flush()
	if n := len(out) - maxLines; n > 0 {
		out = append(out[:maxLines], fmt.Sprintf(m.MoreLines, n)+"\n")
	}
	return strings.Join(out, "")
}

func (c Compiled) count(severity string) int {
	n := 0
	for _, msg := range c.Msgs {
		if msg.Severity == severity {
			n++
		}
	}
	return n
}

func (c Compiled) has(kind string) bool {
	for _, msg := range c.Msgs {
		if msg.Kind == kind {
			return true
		}
	}
	return false
}

// parseMessages splits `lean --json` output into messages and any other lines.
func parseMessages(out string) (msgs []Message, other string) {
	var rest strings.Builder
	for line := range strings.Lines(out) {
		var msg Message
		if strings.HasPrefix(line, "{") && json.Unmarshal([]byte(line), &msg) == nil && msg.Severity != "" {
			msgs = append(msgs, msg)
		} else if strings.TrimSpace(line) != "" {
			rest.WriteString(line)
		}
	}
	return msgs, rest.String()
}

// render formats messages the way plain `lean` prints them, naming the file file:
//
//	file:3:4: error(lean.unknownIdentifier): Unknown identifier `foo`
//	file:5:0: warning: declaration uses `sorry`
//	(1, "a")                                       <- information is printed as is
//
// keep selects the messages to print.
func render(msgs []Message, file string, keep func(Message) bool) string {
	var b strings.Builder
	for _, msg := range msgs {
		if keep != nil && !keep(msg) {
			continue
		}
		if msg.Severity != sevInfo {
			sev := msg.Severity
			if k := msg.kindName(); strings.HasSuffix(msg.Kind, "._namedError") {
				sev += "(" + k + ")"
			}
			fmt.Fprintf(&b, "%s:%d:%d: %s: ", file, msg.Pos.Line, msg.Pos.Column, sev)
		}
		b.WriteString(strings.TrimRight(msg.Data, "\n"))
		b.WriteByte('\n')
	}
	return b.String()
}

// writeExercise writes src as dir/Exercise.lean, creating dir.
func writeExercise(dir string, src []byte) error {
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return err
	}
	return os.WriteFile(filepath.Join(dir, moduleName+".lean"), src, 0o644)
}

// compile compiles dir/Exercise.lean with `lean --json`. Lean writes
// dir/Exercise.olean only when there are no errors.
func compile(ctx context.Context, dir string) (Compiled, error) {
	ctx, cancel := context.WithTimeout(ctx, leanTimeout)
	defer cancel()
	src := filepath.Join(dir, moduleName+".lean")
	cmd := exec.CommandContext(ctx, "lean", "--json", "-R", dir, "-o", filepath.Join(dir, moduleName+".olean"), src)
	cmd.WaitDelay = time.Second
	var stdout, stderr bytes.Buffer
	cmd.Stdout, cmd.Stderr = &stdout, &stderr
	err := cmd.Run()
	msgs, other := parseMessages(stdout.String())
	c := Compiled{Msgs: msgs, Other: trimOutput(other + stderr.String())}
	if errors.Is(ctx.Err(), context.DeadlineExceeded) {
		c.TimedOut = true
		return c, nil
	}
	var ee *exec.ExitError
	if err != nil && !errors.As(err, &ee) {
		return c, fmt.Errorf(m.NoLean, err)
	}
	c.Crash = crashOf(stderr.String(), ee)
	return c, nil
}

// runMain runs the main of dir/Exercise.lean with `lean --run` and returns what it printed,
// shortened by trimOutput.
func runMain(ctx context.Context, dir string) (stdout string, exit int, timedOut bool, err error) {
	ctx, cancel := context.WithTimeout(ctx, runTimeout)
	defer cancel()
	cmd := exec.CommandContext(ctx, "lean", "--run", filepath.Join(dir, moduleName+".lean"))
	cmd.WaitDelay = time.Second
	var out bytes.Buffer
	cmd.Stdout, cmd.Stderr = &out, &out
	err = cmd.Run()
	printed := trimOutput(out.String())
	if errors.Is(ctx.Err(), context.DeadlineExceeded) {
		return printed, -1, true, nil
	}
	var ee *exec.ExitError
	switch {
	case err == nil:
		return printed, 0, false, nil
	case errors.As(err, &ee):
		return printed, ee.ExitCode(), false, nil
	default:
		return "", 0, false, fmt.Errorf(m.NoLean, err)
	}
}

// RefProblem is a difference the checker found between the learner's file and the reference.
type RefProblem struct {
	Problem string `json:"problem"` // missing, kind, statement, definition or axioms
	Decl    string `json:"decl"`
	Detail  string `json:"detail"`
}

func checkerPath(root string) string {
	return filepath.Join(root, "checker", ".lake", "build", "bin", "speclings-check")
}

// compare runs the checker on refDir/Exercise.olean and learnerDir/Exercise.olean.
// With source, the reference is refDir/Exercise.lean, which has errors on purpose:
// the checker elaborates it with Lean's error recovery.
func compare(ctx context.Context, root, refDir, learnerDir string, source bool) ([]RefProblem, error) {
	bin := checkerPath(root)
	if !lings.IsFile(bin) {
		return nil, fmt.Errorf(m.NoChecker, bin)
	}
	ctx, cancel := context.WithTimeout(ctx, leanTimeout)
	defer cancel()
	args := []string{refDir, learnerDir, moduleName}
	if source {
		args = []string{"--source", filepath.Join(refDir, moduleName+".lean"), learnerDir, moduleName}
	}
	cmd := exec.CommandContext(ctx, bin, args...)
	var stdout, stderr bytes.Buffer
	cmd.Stdout, cmd.Stderr = &stdout, &stderr
	err := cmd.Run()
	var ee *exec.ExitError
	if err != nil && !(errors.As(err, &ee) && ee.ExitCode() == 1) {
		return nil, fmt.Errorf("speclings-check: %v %s", err, strings.TrimSpace(stderr.String()))
	}
	var problems []RefProblem
	for line := range strings.Lines(stdout.String()) {
		var p RefProblem
		if err := json.Unmarshal([]byte(line), &p); err != nil {
			return nil, fmt.Errorf("speclings-check: unexpected output %q", line)
		}
		problems = append(problems, p)
	}
	return problems, nil
}

var (
	reLeanVersion = regexp.MustCompile(`version (\d+\.\d+\.\d+\S*?),`)
	reToolchain   = regexp.MustCompile(`^leanprover/lean4:v(\S+)\s*$`)
	reMiseLean    = regexp.MustCompile(`(?m)^"github:leanprover/lean4"\s*=\s*"([^"]+)"`)
)

// leanVersion returns the version of the lean on PATH, e.g. "4.36.0".
func leanVersion(ctx context.Context) (string, error) {
	out, err := exec.CommandContext(ctx, "lean", "--version").Output()
	if err != nil {
		return "", fmt.Errorf(m.NoLean, err)
	}
	mm := reLeanVersion.FindStringSubmatch(string(out))
	if mm == nil {
		return "", fmt.Errorf("unexpected output of lean --version: %q", out)
	}
	return mm[1], nil
}

// toolchainVersion returns the version in repo/lean-toolchain, e.g. "4.36.0".
func toolchainVersion(repo string) (string, error) {
	b, err := os.ReadFile(filepath.Join(repo, "lean-toolchain"))
	if err != nil {
		return "", err
	}
	mm := reToolchain.FindStringSubmatch(string(b))
	if mm == nil {
		return "", fmt.Errorf("lean-toolchain: unexpected content %q", b)
	}
	return mm[1], nil
}

// miseVersion returns the Lean version pinned in repo/mise.toml, e.g. "4.36.0".
func miseVersion(repo string) (string, error) {
	b, err := os.ReadFile(filepath.Join(repo, "mise.toml"))
	if err != nil {
		return "", err
	}
	mm := reMiseLean.FindStringSubmatch(string(b))
	if mm == nil {
		return "", errors.New(`mise.toml: no "github:leanprover/lean4" entry`)
	}
	return mm[1], nil
}
