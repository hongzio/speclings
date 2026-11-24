package main

import (
	"fmt"
	"strings"
)

// exercises is the list of leanlings exercises (the equivalent of ziglings' build.zig).
// The order is the learning order, and each Name must start with "%03d_".
//
//   - exercises/en/<Name>.lean     the broken original. Required: en is the reference language
//   - exercises/<lang>/<Name>.lean a translation. Only comments differ; the code must match en
//   - solutions/<Name>.lean        the solution (en)
//
// Learners work in work/; leanlings copies each exercise there, in their language, when they reach it.
// Never mention line numbers in explanations or hints: comments differ in length, so line numbers differ by language.
var exercises = []Exercise{
	// Part 0: tools. How leanlings and Lean report problems: errors, types, sorry, goals.
	{
		Name:   "001_hello",
		Expect: fix(),
		Broken: Broken{Contains: "Type mismatch", At: "def answer"},
		Hint: L{
			"en": `Read the first error: "42" is a String, but answer is declared as a Nat. Numbers are written without quotes.`,
			"ko": `첫 번째 에러를 읽어 보세요. "42" 는 String 인데 answer 는 Nat 으로 선언되어 있습니다. 숫자는 따옴표 없이 씁니다.`,
		},
	},
	{
		Name:   "002_types",
		Expect: fix(),
		Broken: Broken{Contains: "Neg Nat", At: "def temperature"},
		Hint: L{
			"en": `temperature is negative, so its type must be Int, not Nat. In describe, convert count with toString count, or write the whole String as s!"{name} has {count} letters".`,
			"ko": `temperature 는 음수이므로 타입이 Nat 이 아니라 Int 여야 합니다. describe 에서는 count 를 toString count 로 바꾸거나, 전체를 s!"{name} has {count} letters" 로 쓰세요.`,
		},
	},
	{
		Name:   "003_sorry",
		Expect: fill(),
		Broken: blank("def triple"),
		Hint: L{
			"en": `triple n is n + n + n, or 3 * n. greet name is "Hello, " ++ name ++ "!", or s!"Hello, {name}!".`,
			"ko": `triple n 은 n + n + n, 또는 3 * n 입니다. greet name 은 "Hello, " ++ name ++ "!", 또는 s!"Hello, {name}!" 입니다.`,
		},
	},
	{
		Name:   "004_goals",
		Expect: fill(),
		Broken: blank("theorem two_plus_two"),
		Hint: L{
			"en": "two_plus_two and double_three are equations that hold by computing: rfl. small is decided by computing: decide. In both, the first goal is an equation (rfl) and the second a comparison (decide).",
			"ko": "two_plus_two 와 double_three 는 계산하면 성립하는 등식입니다: rfl. small 은 계산으로 판정됩니다: decide. both 에서 첫 목표는 등식(rfl), 둘째는 비교(decide)입니다.",
		},
	},
}

// Exercise is a single exercise.
type Exercise struct {
	Name   string
	Expect Expect // what a fixed exercise must satisfy
	Broken Broken // how the original (unfixed) exercise should fail; used by -verify only
	Hint   L
}

func (ex Exercise) file() string { return ex.Name + ".lean" }

// Expect is what a fixed exercise must satisfy, on top of compiling with no errors and no sorry
// and keeping every #guard of the original (see checkSource).
type Expect struct {
	// Reference: compare with the original declaration by declaration (checker/). Use it
	// whenever the original compiles apart from its sorrys and # commands: then learners
	// cannot pass by changing a statement or a given definition, or by deleting a theorem.
	// An original that is broken on purpose (a syntax or type error to fix) cannot be the
	// reference; such an exercise must have a #guard that an empty file fails.
	Reference bool
	Output    string   // if set, what main must print (lean --run)
	Forbid    []string // tactics or names the solution must not use, e.g. omega in an exercise on induction
}

// fix is the expectation for an exercise with a mistake to fix.
func fix() Expect { return Expect{} }

// fill is the expectation for an exercise with sorrys to fill in.
func fill() Expect { return Expect{Reference: true} }

func (e Expect) prints(out string) Expect { e.Output = out; return e }

func (e Expect) without(words ...string) Expect { e.Forbid = words; return e }

func (e Expect) String() string {
	s := m.ExpectFix
	if e.Reference {
		s = m.ExpectFill
	}
	if len(e.Forbid) > 0 {
		s += fmt.Sprintf(m.ExpectForbid, strings.Join(e.Forbid, ", "))
	}
	if e.Output != "" {
		s += fmt.Sprintf(m.ExpectOutput, e.Output)
	}
	return s
}

// Broken describes how an original exercise must fail: "in the intended way".
// Failing alone is not enough: a typo elsewhere also fails. So it names a message
// that Lean must report, and the line it must point to.
type Broken struct {
	Severity string // error (the default) or warning
	Kind     string // the message kind, e.g. hasSorry or Tactic.unsolvedGoals; "" for any
	Contains string // a phrase the message must contain
	// At is a code snippet on the line the message points to; a snippet, because line
	// numbers differ by language. Lean reports sorry at the name of the declaration.
	At string
}

// blank is the Broken for an exercise whose first sorry is in the declaration on the line containing at.
func blank(at string) Broken {
	return Broken{Severity: sevWarning, Kind: kindSorry, At: at}
}

// match reports whether msgs, from compiling src, contain the intended failure.
func (b Broken) match(msgs []Message, src string) bool {
	sev := b.Severity
	if sev == "" {
		sev = sevError
	}
	line := 0
	if b.At != "" {
		if line = lineOf(src, b.At); line == 0 {
			return false
		}
	}
	for _, msg := range msgs {
		switch {
		case msg.Severity != sev,
			b.Kind != "" && msg.kindName() != b.Kind,
			b.Contains != "" && !strings.Contains(msg.Data, b.Contains),
			line > 0 && msg.Pos.Line != line:
			continue
		}
		return true
	}
	return false
}
