package main

import (
	"fmt"
	"strings"
)

// exercises is the list of tlings exercises (the equivalent of ziglings' build.zig).
// The order is the learning order, and each Name must start with "%03d_".
//
//   - exercises/en/<Name>.tla, .cfg   the broken original. Required: en is the reference language
//   - exercises/<lang>/<Name>.*       a translation. Only comments differ; the code must match en
//   - solutions/<Name>.tla            the solution (en). Add solutions/<Name>.cfg only if the fix is in the .cfg
//
// Learners work in work/; tlings copies each exercise there, in their language, when they reach it.
// Never mention line numbers in explanations or hints: comments differ in length, so line numbers differ by language.
var exercises = []Exercise{
	{
		Name:   "001_module",
		Expect: constant(),
		Broken: Broken{Exit: exitParse, Contains: "does not match the name"},
		Hint: L{
			"en": "The module name must be the file name without .tla.",
			"ko": "모듈 이름은 파일 이름에서 .tla 를 뺀 것과 같아야 합니다.",
		},
	},
	{
		Name:   "002_extends",
		Expect: constant(),
		Broken: Broken{Exit: exitParse, Contains: "Could not find declaration or definition of symbol '+'", At: "Two == 1 + 1"},
		Hint: L{
			"en": "+ is defined in the Naturals module. Write EXTENDS on the line right after the module header.",
			"ko": "+ 는 Naturals 모듈에 정의되어 있습니다. 모듈 헤더 바로 다음 줄에 EXTENDS 를 쓰세요.",
		},
	},
	{
		Name:   "003_assume",
		Expect: constant(),
		Broken: Broken{Exit: exitAssume, Contains: "Assumption line", At: "ASSUME Two * Two * Two"},
		Hint: L{
			"en": `The "line N, col M" in the error message is where the false ASSUME is.`,
			"ko": `에러 메시지의 "line N, col M" 이 거짓인 ASSUME 의 위치입니다.`,
		},
	},
}

// Exercise is a single exercise.
type Exercise struct {
	Name   string
	Expect Expect // what TLC should report once the exercise is fixed
	Broken Broken // how the original (unfixed) exercise should fail; used by -verify only
	Hint   L
}

// Broken describes how an original exercise must fail: "in the intended way".
// The exit code alone would also accept a syntax error on some other line, so the output and the location are checked too.
type Broken struct {
	Exit     int
	Contains string // a phrase TLC's output must contain
	At       string // a code snippet on the line the error must point to; a snippet, because line numbers differ by language
}

// match reports whether r, the result of checking src, is the intended failure.
func (b Broken) match(r Result, src string) bool {
	if r.Exit != b.Exit || !strings.Contains(r.Output, b.Contains) {
		return false
	}
	if b.At == "" {
		return true
	}
	n := lineOf(src, b.At)
	return n > 0 && strings.Contains(r.Output, fmt.Sprintf("line %d,", n))
}

// lineOf returns the 1-based number of the first line of src containing snippet, or 0.
func lineOf(src, snippet string) int {
	for i, line := range strings.Split(src, "\n") {
		if strings.Contains(line, snippet) {
			return i + 1
		}
	}
	return 0
}

type Kind int

const (
	Holds     Kind = iota // no errors, and exactly States distinct states
	Violates              // Invariant is violated, with a counterexample of TraceLen states
	Deadlocks             // deadlock, with a counterexample of TraceLen states
)

// Expect is what TLC should report for a fixed spec.
//
// Holds also checks the number of states: setting Init or Next to FALSE makes
// every invariant "hold", and the exit code alone cannot tell fixing a spec from deleting it.
type Expect struct {
	Kind      Kind
	States    int
	Invariant string
	TraceLen  int
}

// constant is the expectation for a module without variables (only ASSUMEs are evaluated).
func constant() Expect        { return Expect{Kind: Holds, States: 0} }
func holds(states int) Expect { return Expect{Kind: Holds, States: states} }
func violates(inv string, traceLen int) Expect {
	return Expect{Kind: Violates, Invariant: inv, TraceLen: traceLen}
}
func deadlocks(traceLen int) Expect { return Expect{Kind: Deadlocks, TraceLen: traceLen} }

func (e Expect) String() string {
	switch e.Kind {
	case Violates:
		return fmt.Sprintf(m.ExpectViolation, e.Invariant, e.TraceLen)
	case Deadlocks:
		return fmt.Sprintf(m.ExpectDeadlock, e.TraceLen)
	default:
		if e.States == 0 {
			return m.ExpectNoError
		}
		return fmt.Sprintf(m.ExpectStates, e.States)
	}
}

// judge reports whether r meets e. If not, it also returns the reason to show the learner.
func judge(e Expect, r Result) (ok bool, why string) {
	want := map[Kind]int{Holds: exitOK, Violates: exitSafety, Deadlocks: exitDeadlock}[e.Kind]
	if r.Exit != want {
		return false, describe(r)
	}
	switch {
	case e.Kind == Holds && r.Distinct != e.States:
		return false, fmt.Sprintf(m.WrongStates, r.Distinct, e.States)
	case e.Kind == Violates && r.Violated != e.Invariant:
		return false, fmt.Sprintf(m.WrongInvariant, r.Violated, e.Invariant)
	case e.Kind != Holds && r.TraceLen != e.TraceLen:
		return false, fmt.Sprintf(m.WrongTraceLen, describe(r), r.TraceLen, e.TraceLen)
	}
	return true, ""
}
