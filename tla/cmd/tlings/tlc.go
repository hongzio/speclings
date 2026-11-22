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
	"time"
)

// TLC exit codes (tlc2.output.EC.ExitStatus). All but 13 were confirmed with TLC 1.8.0.
const (
	exitOK       = 0
	exitAssume   = 10
	exitDeadlock = 11
	exitSafety   = 12
	exitLiveness = 13
	exitError    = 75 // e.g. an expression TLC cannot evaluate
	exitParse    = 150
	exitConfig   = 151

	exitTimeout = -1 // not from TLC: tlings stopped it after tlcTimeout
)

// tlcTimeout bounds each TLC run. Exercises finish in about a second, so a run
// that takes longer most likely explores an infinite state space.
const tlcTimeout = 30 * time.Second

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
	return runTLCWithin(ctx, dir, name, tlcTimeout)
}

// runTLCWithin is runTLC with a custom timeout. A run that times out is not an
// error: it returns a Result with Exit exitTimeout and the output so far.
func runTLCWithin(ctx context.Context, dir, name string, timeout time.Duration) (Result, error) {
	ctx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()
	meta, err := os.MkdirTemp("", "tlings-")
	if err != nil {
		return Result{}, err
	}
	defer os.RemoveAll(meta)

	cmd := exec.CommandContext(ctx, "tlc", "-workers", "1", "-metadir", meta, "-noGenerateSpecTE", name+".tla")
	cmd.Dir = dir
	cmd.WaitDelay = time.Second
	out, err := cmd.CombinedOutput()
	if errors.Is(ctx.Err(), context.DeadlineExceeded) {
		return parseResult(exitTimeout, string(out)), nil
	}
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
	case exitError:
		return m.ExitError
	case exitTimeout:
		return fmt.Sprintf(m.ExitTimeout, tlcTimeout)
	default:
		return fmt.Sprintf(m.ExitOther, r.Exit)
	}
}
