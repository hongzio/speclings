package main

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
)

// moduleName is the module every exercise is compiled as. leanlings copies the file
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
	Other    string // output that is not a message (unusual)
	TimedOut bool
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
	c := Compiled{Msgs: msgs, Other: other + stderr.String()}
	if errors.Is(ctx.Err(), context.DeadlineExceeded) {
		c.TimedOut = true
		return c, nil
	}
	var ee *exec.ExitError
	if err != nil && !errors.As(err, &ee) {
		return c, fmt.Errorf(m.NoLean, err)
	}
	return c, nil
}

// runMain runs the main of dir/Exercise.lean with `lean --run` and returns what it printed.
func runMain(ctx context.Context, dir string) (stdout string, exit int, timedOut bool, err error) {
	ctx, cancel := context.WithTimeout(ctx, runTimeout)
	defer cancel()
	cmd := exec.CommandContext(ctx, "lean", "--run", filepath.Join(dir, moduleName+".lean"))
	cmd.WaitDelay = time.Second
	var out bytes.Buffer
	cmd.Stdout, cmd.Stderr = &out, &out
	err = cmd.Run()
	if errors.Is(ctx.Err(), context.DeadlineExceeded) {
		return out.String(), -1, true, nil
	}
	var ee *exec.ExitError
	switch {
	case err == nil:
		return out.String(), 0, false, nil
	case errors.As(err, &ee):
		return out.String(), ee.ExitCode(), false, nil
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
	return filepath.Join(root, "checker", ".lake", "build", "bin", "leanlings-check")
}

// compare runs the checker on refDir/Exercise.olean and learnerDir/Exercise.olean.
func compare(ctx context.Context, root, refDir, learnerDir string) ([]RefProblem, error) {
	bin := checkerPath(root)
	if !isFile(bin) {
		return nil, fmt.Errorf(m.NoChecker, bin)
	}
	ctx, cancel := context.WithTimeout(ctx, leanTimeout)
	defer cancel()
	cmd := exec.CommandContext(ctx, bin, refDir, learnerDir, moduleName)
	var stdout, stderr bytes.Buffer
	cmd.Stdout, cmd.Stderr = &stdout, &stderr
	err := cmd.Run()
	var ee *exec.ExitError
	if err != nil && !(errors.As(err, &ee) && ee.ExitCode() == 1) {
		return nil, fmt.Errorf("leanlings-check: %v %s", err, strings.TrimSpace(stderr.String()))
	}
	var problems []RefProblem
	for line := range strings.Lines(stdout.String()) {
		var p RefProblem
		if err := json.Unmarshal([]byte(line), &p); err != nil {
			return nil, fmt.Errorf("leanlings-check: unexpected output %q", line)
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

// toolchainVersion returns the version in root/lean-toolchain, e.g. "4.36.0".
func toolchainVersion(root string) (string, error) {
	b, err := os.ReadFile(filepath.Join(root, "lean-toolchain"))
	if err != nil {
		return "", err
	}
	mm := reToolchain.FindStringSubmatch(string(b))
	if mm == nil {
		return "", fmt.Errorf("lean-toolchain: unexpected content %q", b)
	}
	return mm[1], nil
}

// miseVersion returns the Lean version pinned in root/mise.toml, e.g. "4.36.0".
func miseVersion(root string) (string, error) {
	b, err := os.ReadFile(filepath.Join(root, "mise.toml"))
	if err != nil {
		return "", err
	}
	mm := reMiseLean.FindStringSubmatch(string(b))
	if mm == nil {
		return "", errors.New(`mise.toml: no "github:leanprover/lean4" entry`)
	}
	return mm[1], nil
}
