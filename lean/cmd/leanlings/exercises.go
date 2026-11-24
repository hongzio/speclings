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

	// Part 1: values and functions. Programming with Nat, Int, Bool, functions, recursion, List, Option and pairs.
	{
		Name:   "005_nat",
		Expect: fill(),
		Broken: blank("#guard 7 / 2"),
		Hint: L{
			"en": "Division rounds down and drops the remainder. A subtraction that would go below 0 gives 0, and so does dividing by 0. Evaluate the inner parentheses first.",
			"ko": "나눗셈은 내림하고 나머지를 버립니다. 0 아래로 내려가는 뺄셈은 0 이고, 0 으로 나누는 것도 0 입니다. 안쪽 괄호부터 계산하세요.",
		},
	},
	{
		Name:   "006_int",
		Expect: fix(),
		Broken: blank("#guard (-7 : Int) / 2"),
		Hint: L{
			"en": "-7 / 2 rounds down to -4, so the remainder is 1. In change, give diff the type Int (let diff : Int := ...): then Lean converts paid and price to Int before subtracting.",
			"ko": "-7 / 2 는 -4 로 내림되므로 나머지는 1 입니다. change 에서는 diff 에 Int 타입을 주세요 (let diff : Int := ...). 그러면 Lean 이 빼기 전에 paid 와 price 를 Int 로 바꿉니다.",
		},
	},
	{
		Name:   "007_bool",
		Expect: fill(),
		Broken: blank("def isEven"),
		Hint: L{
			"en": "n is even when n % 2 == 0. A leap year: divisible by 4 && (not divisible by 100 || divisible by 400).",
			"ko": "n % 2 == 0 이면 짝수입니다. 윤년: 4 로 나누어떨어지고 && (100 으로 나누어떨어지지 않거나 || 400 으로 나누어떨어짐).",
		},
	},
	{
		Name:   "008_if_let",
		Expect: fix(),
		Broken: Broken{Contains: "expected 'else'", At: "def abs"},
		Hint: L{
			"en": "abs needs an else: the value when x is not negative is x itself. For clamp, first let atLeastLo := if x < lo then lo else x, then cap it at hi the same way.",
			"ko": "abs 에는 else 가 필요합니다. x 가 음수가 아닐 때의 값은 x 그대로입니다. clamp 는 먼저 let atLeastLo := if x < lo then lo else x 로 두고, 같은 방법으로 hi 를 넘지 않게 하세요.",
		},
	},
	{
		Name:   "009_functions",
		Expect: fix(),
		Broken: Broken{Contains: "Type mismatch", At: "def square"},
		Hint: L{
			"en": "area side is still waiting for its second argument: a square has the same width and height. areaWithWidth2 is area applied to 2 only.",
			"ko": "area side 는 아직 두 번째 인자를 기다리고 있습니다. 정사각형은 가로와 세로가 같습니다. areaWithWidth2 는 area 에 2 만 준 것입니다.",
		},
	},
	{
		Name:   "010_lambdas",
		Expect: fix(),
		Broken: Broken{Contains: "expected '↦', '=>'", At: "def doubled"},
		Hint: L{
			"en": "Lean writes fun x => ..., not ->. twice f x is f (f x). compose g f is fun x => g (f x).",
			"ko": "Lean 은 -> 가 아니라 fun x => ... 로 씁니다. twice f x 는 f (f x) 입니다. compose g f 는 fun x => g (f x) 입니다.",
		},
	},
	{
		Name:   "011_match",
		Expect: fix(),
		Broken: Broken{Contains: "Missing cases", At: `| 0 => "none"`},
		Hint: L{
			"en": `Add a last case | _ => "many" to size. minusTwo has three cases: 0, 1, and n + 2.`,
			"ko": `size 에 마지막 경우 | _ => "many" 를 더하세요. minusTwo 는 0, 1, n + 2 의 세 경우입니다.`,
		},
	},
	{
		Name:   "012_recursion",
		Expect: fix(),
		Broken: Broken{Contains: "fail to show termination", At: "def sumTo"},
		Hint: L{
			"en": "sumTo (n + 1) calls itself on the same argument, so it never stops: call it on n. fib has three cases: 0, 1, and n + 2, which is fib n + fib (n + 1).",
			"ko": "sumTo (n + 1) 은 같은 인자로 자신을 불러서 끝나지 않습니다. n 으로 부르세요. fib 는 0, 1, n + 2 의 세 경우이고, n + 2 는 fib n + fib (n + 1) 입니다.",
		},
	},
	{
		Name:   "013_lists",
		Expect: fill().without("length", "sum", "contains", "elem", "foldl", "foldr", "any"),
		Broken: blank("def len"),
		Hint: L{
			"en": "Each has two cases. len: [] is 0, and _ :: xs is 1 + len xs. total is similar. has: match xs with | [] => false | x :: rest => x == y || has rest y.",
			"ko": "모두 두 경우입니다. len: [] 는 0, _ :: xs 는 1 + len xs. total 도 비슷합니다. has: match xs with | [] => false | x :: rest => x == y || has rest y.",
		},
	},
	{
		Name:   "014_list_functions",
		Expect: fill(),
		Broken: blank("def squares"),
		Hint: L{
			"en": "squares: map (· ^ 2) over List.range n. evens: filter. product: foldl with (· * ·), starting from 1. sumOfOddSquares: range, then filter, map and foldl.",
			"ko": "squares: List.range n 에 map (· ^ 2). evens: filter. product: 1 에서 시작하는 (· * ·) 의 foldl. sumOfOddSquares: range 다음에 filter, map, foldl.",
		},
	},
	{
		Name:   "015_option",
		Expect: fix(),
		Broken: Broken{Contains: "Type mismatch", At: "def first"},
		Hint: L{
			"en": "first is xs.head?. firstOr: (first xs).getD fallback. safeDiv: if b == 0 then none else some (a / b).",
			"ko": "first 는 xs.head? 입니다. firstOr: (first xs).getD fallback. safeDiv: if b == 0 then none else some (a / b).",
		},
	},
	{
		Name:   "016_pairs",
		Expect: fill(),
		Broken: blank("def divMod"),
		Hint: L{
			"en": "divMod a b is (a / b, a % b). swap p is (p.2, p.1). sumPairs maps fun (a, b) => a + b. indexed zips List.range xs.length with xs.",
			"ko": "divMod a b 는 (a / b, a % b), swap p 는 (p.2, p.1) 입니다. sumPairs 는 fun (a, b) => a + b 로 map 합니다. indexed 는 List.range xs.length 와 xs 를 zip 합니다.",
		},
	},
	{
		Name:   "017_quiz1",
		Expect: fill(),
		Broken: blank("def digits"),
		Hint: L{
			"en": "digits n: if n < 10 then [n] else digits (n / 10) ++ [n % 10]. digitSum folds digits n. fizzbuzz: an if ... else if chain, testing 15 first; toString n for the rest. fizzbuzzUpTo maps over List.range n, adding 1.",
			"ko": "digits n: if n < 10 then [n] else digits (n / 10) ++ [n % 10]. digitSum 은 digits n 을 fold 합니다. fizzbuzz: 15 부터 검사하는 if ... else if 사슬이고, 나머지는 toString n. fizzbuzzUpTo 는 List.range n 에 1 을 더해 map 합니다.",
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
