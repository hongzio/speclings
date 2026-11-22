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

	// Part 1: values. Modules without variables; every ASSUME must hold.
	{
		Name:   "004_integers",
		Expect: constant(),
		Broken: blank(`ASSUME 7 \div 2 = ???`),
		Hint: L{
			"en": "Replace every ??? with a value. Division rounds down, toward minus infinity, and a % b is never negative.",
			"ko": "??? 를 모두 값으로 바꾸세요. 나눗셈은 음의 무한대 쪽으로 내림하고, a % b 는 음수가 되지 않습니다.",
		},
	},
	{
		Name:   "005_booleans",
		Expect: constant(),
		Broken: blank(`ASSUME (TRUE /\ FALSE) = ???`),
		Hint: L{
			"en": "A => B is FALSE only when A is TRUE and B is FALSE.",
			"ko": "A => B 는 A 가 TRUE 이고 B 가 FALSE 일 때만 FALSE 입니다.",
		},
	},
	{
		Name:   "006_bullets",
		Expect: constant(),
		Broken: Broken{Exit: exitAssume, Contains: "Assumption line", At: "ASSUME ~SmallOrEven(-4)"},
		Hint: L{
			"en": `The two \/ bullets must be in the same column, to the right of the /\ bullet they belong to.`,
			"ko": `두 \/ 는 같은 열에, 그리고 자신이 속한 /\ 보다 오른쪽에 있어야 합니다.`,
		},
	},
	{
		Name:   "007_definitions",
		Expect: constant(),
		Broken: blank("Sq(n) == ???"),
		Hint: L{
			"en": `Replace ??? with an expression using n. If TLC then reports "Unknown operator", a name is used above its definition: move that definition down.`,
			"ko": `??? 를 n 을 쓰는 식으로 바꾸세요. 그다음 TLC 가 "Unknown operator" 를 보고하면 이름이 정의보다 위에서 쓰인 것이니, 그 정의를 아래로 옮기세요.`,
		},
	},
	{
		Name:   "008_conditionals",
		Expect: constant(),
		Broken: Broken{Exit: exitParse, Contains: "IF THEN ELSE starting at line", At: "Abs(x) == IF"},
		Hint: L{
			"en": "IF needs an ELSE. A CASE whose conditions can all be false needs an OTHER. d is the difference between a and b.",
			"ko": "IF 에는 ELSE 가 필요합니다. 조건이 모두 거짓일 수 있는 CASE 에는 OTHER 가 필요합니다. d 는 a 와 b 의 차입니다.",
		},
	},
	{
		Name:   "009_sets",
		Expect: constant(),
		Broken: blank("ASSUME {3, 1, 2} = {1, 2, ???}"),
		Hint: L{
			"en": "Order and repetition do not matter in a set. The empty set is a subset of every set.",
			"ko": "집합에서는 순서와 중복이 상관없습니다. 공집합은 모든 집합의 부분집합입니다.",
		},
	},
	{
		Name:   "010_quantifiers",
		Expect: constant(),
		Broken: blank("AllPositive(S) == ???"),
		Hint: L{
			"en": `AllPositive is a \A formula over S, and SomeAbove is a \E formula over S.`,
			"ko": `AllPositive 는 S 에 대한 \A 식이고, SomeAbove 는 S 에 대한 \E 식입니다.`,
		},
	},
	{
		Name:   "011_set_builders",
		Expect: constant(),
		Broken: blank("MultiplesOf3(S) == ???"),
		Hint: L{
			"en": `MultiplesOf3 filters S: {x \in S : ...}. Inc maps S: {... : x \in S}.`,
			"ko": `MultiplesOf3 는 S 를 거릅니다: {x \in S : ...}. Inc 는 S 를 변환합니다: {... : x \in S}.`,
		},
	},
	{
		Name:   "012_subset_union",
		Expect: constant(),
		Broken: blank("ASSUME Cardinality({4, 5, 6}) = ???"),
		Hint: L{
			"en": "A set of n elements has 2^n subsets. The empty set has exactly one subset: itself.",
			"ko": "원소가 n 개인 집합의 부분집합은 2^n 개입니다. 공집합의 부분집합은 자기 자신 하나뿐입니다.",
		},
	},
	{
		Name:   "013_choose",
		Expect: constant(),
		Broken: blank(`Max(S) == CHOOSE x \in S : ???`),
		Hint: L{
			"en": "x is the largest element of S when every y in S is at most x.",
			"ko": "S 의 모든 y 가 x 이하이면 x 가 가장 큰 원소입니다.",
		},
	},
	{
		Name:   "014_functions",
		Expect: constant(),
		Broken: blank("balance == ???"),
		Hint: L{
			"en": `balance maps each of "alice" and "bob" to 10: [a \in ... |-> ...].`,
			"ko": `balance 는 "alice" 와 "bob" 각각을 10 으로 보냅니다: [a \in ... |-> ...].`,
		},
	},
	{
		Name:   "015_function_sets",
		Expect: constant(),
		Broken: blank("ASSUME Cardinality(Flags) = ???"),
		Hint: L{
			"en": "[S -> T] has |T|^|S| elements, and the domain of each one is exactly S.",
			"ko": "[S -> T] 의 원소는 |T|^|S| 개이고, 각 원소의 정의역은 정확히 S 입니다.",
		},
	},
	{
		Name:   "016_except",
		Expect: constant(),
		Broken: blank("Move(b, from, to, amt) == ???"),
		Hint: L{
			"en": "Change two keys in one EXCEPT: subtract at from, add at to. @ is the old value.",
			"ko": "EXCEPT 하나로 키 두 개를 바꾸세요: from 에서 빼고 to 에 더합니다. @ 는 원래 값입니다.",
		},
	},
	{
		Name:   "017_records",
		Expect: constant(),
		Broken: blank("ASSUME r.to = ???"),
		Hint: L{
			"en": "A record is a function from field names to values, so its DOMAIN is a set of strings.",
			"ko": "레코드는 필드 이름에서 값으로 가는 함수이므로, DOMAIN 은 문자열의 집합입니다.",
		},
	},
	{
		Name:   "018_sequences",
		Expect: constant(),
		Broken: blank("Send(queue, m) == ???"),
		Hint: L{
			"en": "Send uses Append. Receive keeps everything after the first message.",
			"ko": "Send 는 Append 를 씁니다. Receive 는 첫 메시지 뒤의 나머지를 남깁니다.",
		},
	},
	{
		Name:   "019_recursion",
		Expect: constant(),
		Broken: blank("Product(S) == ???"),
		Hint: L{
			"en": "Product mirrors Sum, with 1 for the empty set. Then declare both above their definitions: RECURSIVE Sum(_), Product(_).",
			"ko": "Product 는 Sum 과 같은 모양이고, 공집합이면 1 입니다. 그다음 두 정의 위에 둘 다 선언하세요: RECURSIVE Sum(_), Product(_).",
		},
	},
	{
		Name:   "020_quiz1",
		Expect: constant(),
		Broken: blank("Requests == ???"),
		Hint: L{
			"en": "Requests filters a set of records (017, 011). Assignments is a set of functions (015). To count requests: ordered pairs of different accounts, times the amounts.",
			"ko": "Requests 는 레코드 집합을 거른 것입니다 (017, 011). Assignments 는 함수의 집합입니다 (015). 요청 수: 서로 다른 계좌의 순서쌍 수 곱하기 금액 수.",
		},
	},
}

// blank is the Broken for an exercise whose first problem is a ??? on the line containing at.
func blank(at string) Broken {
	return Broken{Exit: exitParse, Contains: "Lexical error", At: at}
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
