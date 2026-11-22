package main

import (
	"context"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
)

// TLC exit codes (tlc2.output.EC.ExitStatus). 0, 10, 11, 12 and 150 were confirmed with TLC 1.8.0.
const (
	exitOK       = 0
	exitAssume   = 10
	exitDeadlock = 11
	exitSafety   = 12
	exitLiveness = 13
	exitParse    = 150
	exitConfig   = 151
)

// Result is the result of one TLC run.
type Result struct {
	Exit     int
	Output   string
	Distinct int    // number of distinct states; -1 if not in the output
	Violated string // name of the violated invariant
	TraceLen int    // number of states in the counterexample; 0 if none
}

var (
	reDistinct = regexp.MustCompile(`([\d,]+) distinct states found`)
	reViolated = regexp.MustCompile(`(?m)^Error: Invariant (\S+) is violated\.`)
	reState    = regexp.MustCompile(`(?m)^State (\d+): `)
)

func parseResult(exit int, out string) Result {
	r := Result{Exit: exit, Output: out, Distinct: -1}
	if m := reDistinct.FindStringSubmatch(out); m != nil {
		r.Distinct, _ = strconv.Atoi(strings.ReplaceAll(m[1], ",", ""))
	}
	if m := reViolated.FindStringSubmatch(out); m != nil {
		r.Violated = m[1]
	}
	for _, m := range reState.FindAllStringSubmatch(out, -1) {
		n, _ := strconv.Atoi(m[1])
		r.TraceLen = max(r.TraceLen, n)
	}
	return r
}

// runTLC model-checks <name>.tla in dir with <name>.cfg.
// It uses BFS with a single worker so results (state counts, shortest counterexamples) are reproducible,
// and keeps states/ and *_TTrace_* files out of dir.
func runTLC(ctx context.Context, dir, name string) (Result, error) {
	meta, err := os.MkdirTemp("", "tlings-")
	if err != nil {
		return Result{}, err
	}
	defer os.RemoveAll(meta)

	cmd := exec.CommandContext(ctx, "tlc", "-workers", "1", "-metadir", meta, "-noGenerateSpecTE", name+".tla")
	cmd.Dir = dir
	out, err := cmd.CombinedOutput()
	exit := 0
	if err != nil {
		var ee *exec.ExitError
		if !errors.As(err, &ee) {
			return Result{}, fmt.Errorf(m.NoTLC, err)
		}
		exit = ee.ExitCode()
	}
	return parseResult(exit, string(out)), nil
}

// describe turns an exit code into a one-line explanation for the learner.
func describe(r Result) string {
	switch r.Exit {
	case exitOK:
		return m.ExitOK
	case exitAssume:
		return m.ExitAssume
	case exitDeadlock:
		return fmt.Sprintf(m.ExitDeadlock, r.TraceLen)
	case exitSafety:
		return fmt.Sprintf(m.ExitSafety, r.Violated, r.TraceLen)
	case exitLiveness:
		return m.ExitLiveness
	case exitParse:
		return m.ExitParse
	case exitConfig:
		return m.ExitConfig
	default:
		return fmt.Sprintf(m.ExitOther, r.Exit)
	}
}
