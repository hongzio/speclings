package track

import (
	"fmt"
	"strings"
)

// exercises is the list of exercises of the Lean track (the equivalent of ziglings' build.zig).
// The order is the learning order, and each Name must start with "%03d_". Paths are relative to lean/:
//
//   - exercises/en/<Name>.lean     the broken original. Required: en is the reference language
//   - exercises/<lang>/<Name>.lean a translation. Only comments differ; the code must match en
//   - solutions/<Name>.lean        the solution (en)
//
// Learners work in work/lean/; speclings copies each exercise there, in their language, when they reach it.
// Never mention line numbers in explanations or hints: comments differ in length, so line numbers differ by language.
var exercises = []Exercise{
	// Part 0: tools. How speclings and Lean report problems: errors, types, sorry, goals.
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

	// Part 2: data. Defining types: structures, inductive types, trees, polymorphism, namespaces and type classes.
	{
		Name:   "018_structures",
		Expect: fix(),
		Broken: Broken{Contains: "Fields missing", At: "def origin"},
		Hint: L{
			"en": "origin needs both fields: { x := 0, y := 0 }. moveRight: { p with x := p.x + dx }. add: ⟨p.x + q.x, p.y + q.y⟩.",
			"ko": "origin 에는 두 필드가 모두 필요합니다: { x := 0, y := 0 }. moveRight: { p with x := p.x + dx }. add: ⟨p.x + q.x, p.y + q.y⟩.",
		},
	},
	{
		Name:   "019_deriving",
		Expect: fix(),
		Broken: Broken{Contains: "BEq Point", At: "#guard p == ⟨1, 2⟩"},
		Hint: L{
			"en": "Add the line deriving BEq, Repr at the end of the structure, indented like the fields. swapXY p is ⟨p.y, p.x⟩.",
			"ko": "structure 끝에 필드와 같은 들여쓰기로 deriving BEq, Repr 줄을 더하세요. swapXY p 는 ⟨p.y, p.x⟩ 입니다.",
		},
	},
	{
		Name:   "020_enums",
		Expect: fill(),
		Broken: blank("def isWeekend"),
		Hint: L{
			"en": "isWeekend: | .saturday | .sunday => true and | _ => false. next has one case per day, and .sunday goes back to .monday.",
			"ko": "isWeekend: | .saturday | .sunday => true 와 | _ => false. next 는 요일마다 한 경우이고, .sunday 다음은 다시 .monday 입니다.",
		},
	},
	{
		Name:   "021_inductive_data",
		Expect: fill(),
		Broken: blank("def area"),
		Hint: L{
			"en": "Match with one case per constructor: | .square s => ... | .rect w h => ... | .triangle b h => .... A triangle's area is b * h / 2. In isSquare, a rectangle is a square when w == h.",
			"ko": "생성자마다 한 경우로 match 하세요: | .square s => ... | .rect w h => ... | .triangle b h => .... 삼각형의 넓이는 b * h / 2 입니다. isSquare 에서 직사각형은 w == h 일 때 정사각형입니다.",
		},
	},
	{
		Name:   "022_trees",
		Expect: fill(),
		Broken: blank("def size"),
		Hint: L{
			"en": "Two cases each, | .leaf => ... and | .node l v r => .... size: size l + 1 + size r. depth: 1 + max (depth l) (depth r). mirror swaps l and r, mirroring both. toList: toList l ++ [v] ++ toList r.",
			"ko": "모두 | .leaf => ... 와 | .node l v r => ... 의 두 경우입니다. size: size l + 1 + size r. depth: 1 + max (depth l) (depth r). mirror 는 l 과 r 을 바꾸고 둘 다 mirror 합니다. toList: toList l ++ [v] ++ toList r.",
		},
	},
	{
		Name:   "023_expressions",
		Expect: fill(),
		Broken: blank("def eval"),
		Hint: L{
			"en": `eval: | .add a b => eval a + eval b, and the same for mul. render: s!"({render a} + {render b})". simplify (.add a b): match simplify a, simplify b with | .num 0, b' => b' | a', .num 0 => a' | a', b' => .add a' b', and the same with 1 for mul.`,
			"ko": `eval: | .add a b => eval a + eval b, mul 도 같은 식입니다. render: s!"({render a} + {render b})". simplify (.add a b): match simplify a, simplify b with | .num 0, b' => b' | a', .num 0 => a' | a', b' => .add a' b', mul 은 1 로 같은 식입니다.`,
		},
	},
	{
		Name:   "024_polymorphism",
		Expect: fill(),
		Broken: blank("def swap"),
		Hint: L{
			"en": "swap p is (p.2, p.1). mapOption: | none => none | some x => some (f x). mapTree: | .leaf => .leaf | .node l v r => .node (mapTree f l) (f v) (mapTree f r).",
			"ko": "swap p 는 (p.2, p.1) 입니다. mapOption: | none => none | some x => some (f x). mapTree: | .leaf => .leaf | .node l v r => .node (mapTree f l) (f v) (mapTree f r).",
		},
	},
	{
		Name:   "025_namespaces",
		Expect: fix(),
		Broken: Broken{Contains: "Invalid field", At: "#guard sample.size"},
		Hint: L{
			"en": "Rename size to Tree.size (def Tree.size ...); inside it, size still refers to itself. sum: | leaf => 0 | node l v r => sum l + v + sum r.",
			"ko": "size 의 이름을 Tree.size 로 바꾸세요 (def Tree.size ...). 그 안에서 size 는 여전히 자기 자신입니다. sum: | leaf => 0 | node l v r => sum l + v + sum r.",
		},
	},
	{
		Name:   "026_instances",
		Expect: fix(),
		Broken: Broken{Contains: "HAdd Point Point", At: "def shift"},
		Hint: L{
			"en": `Before shift: instance : Add Point where add p q := ⟨p.x + q.x, p.y + q.y⟩. toString p is s!"({p.x}, {p.y})".`,
			"ko": `shift 앞에: instance : Add Point where add p q := ⟨p.x + q.x, p.y + q.y⟩. toString p 는 s!"({p.x}, {p.y})" 입니다.`,
		},
	},
	{
		Name:   "027_classes",
		Expect: fix(),
		Broken: Broken{Contains: "BEq α", At: "def count"},
		Hint: L{
			"en": `Add [BEq α] after {α : Type} in count. describe n is s!"the number {n}". describeAll maps Describe.describe. The list instance: "[" ++ ", ".intercalate (describeAll xs) ++ "]".`,
			"ko": `count 의 {α : Type} 다음에 [BEq α] 를 더하세요. describe n 은 s!"the number {n}" 입니다. describeAll 은 Describe.describe 로 map 합니다. 리스트 instance: "[" ++ ", ".intercalate (describeAll xs) ++ "]".`,
		},
	},
	{
		Name:   "028_quiz2",
		Expect: fill(),
		Broken: blank("def insert"),
		Hint: L{
			"en": "insert: match t with | leaf => node leaf x leaf | node l v r => if x < v then node (l.insert x) v r else if v < x then node l v (r.insert x) else t. contains follows the same path. ofList: xs.foldl insert leaf.",
			"ko": "insert: match t with | leaf => node leaf x leaf | node l v r => if x < v then node (l.insert x) v r else if v < x then node l v (r.insert x) else t. contains 도 같은 경로를 따라갑니다. ofList: xs.foldl insert leaf.",
		},
	},

	// Part 3: programs. IO, do, mutable variables and loops, arrays, errors, strings and partial functions.
	{
		Name:   "029_main",
		Expect: fix().prints("Hello, speclings!\n"),
		Broken: Broken{Contains: "Type mismatch", At: "def main"},
		Hint: L{
			"en": "IO.println greeting is an action of type IO Unit, so main must have that type: def main : IO Unit := ...",
			"ko": "IO.println greeting 은 IO Unit 타입의 동작이므로 main 도 그 타입이어야 합니다: def main : IO Unit := ...",
		},
	},
	{
		Name:   "030_do",
		Expect: fix().prints("Rolling...\nYou rolled 4, plus one is 5.\n"),
		Broken: Broken{Contains: "ToString (IO Nat)", At: "You rolled"},
		Hint: L{
			"en": "let n := roll names the action. let n ← roll runs it, and n is the Nat it gives.",
			"ko": "let n := roll 은 동작에 이름만 붙입니다. let n ← roll 은 동작을 실행하고, n 은 그 결과인 Nat 입니다.",
		},
	},
	{
		Name:   "031_mut_for",
		Expect: fix().prints("3\n2\n1\nliftoff!\n"),
		Broken: Broken{Contains: "cannot be mutated", At: "sum := sum + x"},
		Hint: L{
			"en": `Declare sum with let mut. countdown: Id.run do, let mut lines := [], then for i in List.range n do lines := toString (i + 1) :: lines, and return lines ++ ["liftoff!"].`,
			"ko": `sum 을 let mut 으로 선언하세요. countdown: Id.run do 안에서 let mut lines := [], 그다음 for i in List.range n do lines := toString (i + 1) :: lines, 마지막에 return lines ++ ["liftoff!"].`,
		},
	},
	{
		Name:   "032_arrays",
		Expect: fill(),
		Broken: blank("def squaresArray"),
		Hint: L{
			"en": "squaresArray: Id.run do with let mut out := #[] and out := out.push (i * i) in a for loop. get: a[i]?.getD 0. histogram: start from Array.replicate buckets 0 and modify x (· + 1) for every x < buckets.",
			"ko": "squaresArray: Id.run do 안에서 let mut out := #[] 로 시작해, for 반복에서 out := out.push (i * i). get: a[i]?.getD 0. histogram: Array.replicate buckets 0 에서 시작해, buckets 보다 작은 x 마다 modify x (· + 1).",
		},
	},
	{
		Name:   "033_except",
		Expect: fill(),
		Broken: blank("def parseAge"),
		Hint: L{
			"en": `parseAge: match s.toNat? with | none => throw s!"not a number: {s}" | some n => if n > 150 then throw s!"too old: {n}" else pure n. averageAge: do, let x ← parseAge a, the same for b, return (x + y) / 2. parseAll: xs.mapM parseAge.`,
			"ko": `parseAge: match s.toNat? with | none => throw s!"not a number: {s}" | some n => if n > 150 then throw s!"too old: {n}" else pure n. averageAge: do 안에서 let x ← parseAge a, b 도 같게, return (x + y) / 2. parseAll: xs.mapM parseAge.`,
		},
	},
	{
		Name:   "034_strings",
		Expect: fill(),
		Broken: blank("def wordCount"),
		Hint: L{
			"en": `wordCount: split on " ", filter out the empty Strings, take the length. sumNumbers: split, filterMap String.toNat?, foldl. onlyDigits: String.ofList of the filtered toList. titleCase: " ".intercalate of the capitalized words.`,
			"ko": `wordCount: " " 로 나누고, 빈 String 을 걸러 내고, 길이를 셉니다. sumNumbers: 나누고, String.toNat? 로 filterMap, foldl. onlyDigits: toList 를 거른 것의 String.ofList. titleCase: capitalize 한 단어들을 " ".intercalate.`,
		},
	},
	{
		Name:   "035_partial",
		Expect: fix(),
		Broken: Broken{Contains: "fail to show termination", At: "def collatz"},
		Hint: L{
			"en": "Write partial def collatz. longestBelow: Id.run do, let mut best := 0, and for i in List.range n, take i when collatz i > collatz best.",
			"ko": "partial def collatz 로 쓰세요. longestBelow: Id.run do 안에서 let mut best := 0, for i in List.range n 에서 collatz i > collatz best 이면 i 로 바꿉니다.",
		},
	},
	{
		Name:   "036_quiz3",
		Expect: fill().prints("the: 3\ncat: 1\nsat: 1\non: 1\nmat: 1\nend: 1\n"),
		Broken: blank("def countWords"),
		Hint: L{
			"en": `countWords: words.foldl (init := []) fun counts w => if counts.any (·.1 == w) then counts.map (fun (v, c) => if v == w then (v, c + 1) else (v, c)) else counts ++ [(w, 1)]. main: for (word, count) in countWords (text.splitOn " ") do IO.println s!"{word}: {count}".`,
			"ko": `countWords: words.foldl (init := []) fun counts w => if counts.any (·.1 == w) then counts.map (fun (v, c) => if v == w then (v, c + 1) else (v, c)) else counts ++ [(w, 1)]. main: for (word, count) in countWords (text.splitOn " ") do IO.println s!"{word}: {count}".`,
		},
	},

	// Part 4: propositions. Proofs as values: →, ∧, ∨, ¬, ↔, ∀, ∃, rewriting, calc and classical logic.
	// The automatic tactics are not accepted (logic), so that learners take the steps themselves.
	{
		Name:   "037_implication",
		Expect: fill().without(logic...),
		Broken: blank("theorem self_imp"),
		Hint: L{
			"en": "self_imp: fun hp => hp. modus_ponens: hpq hp. imp_trans: intro hp, then exact hqr (hpq hp). const_imp: intro hp _, then exact hp.",
			"ko": "self_imp: fun hp => hp. modus_ponens: hpq hp. imp_trans: intro hp 다음 exact hqr (hpq hp). const_imp: intro hp _ 다음 exact hp.",
		},
	},
	{
		Name:   "038_apply",
		Expect: fill().without(logic...),
		Broken: blank("theorem chain"),
		Hint: L{
			"en": "chain: apply h3, apply h2, apply h1, exact hp. two_premises: apply h leaves the goals p and q; close each with assumption. pick: apply h, then assumption.",
			"ko": "chain: apply h3, apply h2, apply h1, exact hp. two_premises: apply h 는 목표 p 와 q 를 남기니 각각 assumption 으로 닫으세요. pick: apply h 다음 assumption.",
		},
	},
	{
		Name:   "039_and",
		Expect: fill().without(logic...),
		Broken: blank("theorem and_swap"),
		Hint: L{
			"en": "and_swap: intro h, exact ⟨h.2, h.1⟩. and_assoc_mp: intro h, obtain ⟨⟨hp, hq⟩, hr⟩ := h, exact ⟨hp, hq, hr⟩. curry: intro h hp hq, exact h ⟨hp, hq⟩. uncurry: intro h hpq, exact h hpq.1 hpq.2.",
			"ko": "and_swap: intro h, exact ⟨h.2, h.1⟩. and_assoc_mp: intro h, obtain ⟨⟨hp, hq⟩, hr⟩ := h, exact ⟨hp, hq, hr⟩. curry: intro h hp hq, exact h ⟨hp, hq⟩. uncurry: intro h hpq, exact h hpq.1 hpq.2.",
		},
	},
	{
		Name:   "040_or",
		Expect: fill().without(logic...),
		Broken: blank("theorem or_swap"),
		Hint: L{
			"en": "or_swap: intro h, rcases h with hp | hq, then right; exact hp in the first case and left; exact hq in the second. or_elim: the same cases, with hpr and hqr. and_or_distrib: intro ⟨hp, hqr⟩, rcases hqr with hq | hr, then Or.inl ⟨hp, hq⟩ or Or.inr ⟨hp, hr⟩.",
			"ko": "or_swap: intro h, rcases h with hp | hq 다음, 첫 경우는 right; exact hp, 둘째는 left; exact hq. or_elim: 같은 경우 나누기에 hpr 과 hqr. and_or_distrib: intro ⟨hp, hqr⟩, rcases hqr with hq | hr 다음 Or.inl ⟨hp, hq⟩ 또는 Or.inr ⟨hp, hr⟩.",
		},
	},
	{
		Name:   "041_not",
		Expect: fill().without(logic...),
		Broken: blank("theorem double_neg_intro"),
		Hint: L{
			"en": "double_neg_intro: intro hp hnp, exact hnp hp. contrapositive: intro hpq hnq hp, exact hnq (hpq hp). not_and_left: intro hnp ⟨hp, _⟩, exact hnp hp. absurd_example: intro hp hnp, exfalso, exact hnp hp. not_both: intro ⟨hp, hnp⟩, contradiction.",
			"ko": "double_neg_intro: intro hp hnp, exact hnp hp. contrapositive: intro hpq hnq hp, exact hnq (hpq hp). not_and_left: intro hnp ⟨hp, _⟩, exact hnp hp. absurd_example: intro hp hnp, exfalso, exact hnp hp. not_both: intro ⟨hp, hnp⟩, contradiction.",
		},
	},
	{
		Name:   "042_iff",
		Expect: fill().without(logic...),
		Broken: blank("theorem and_comm_iff"),
		Hint: L{
			"en": "constructor, then prove each direction. not_or_iff, left to right: ⟨fun hp => h (Or.inl hp), fun hq => h (Or.inr hq)⟩. Right to left: intro ⟨hnp, hnq⟩ h, then cases on h. iff_use: h.mpr hq.",
			"ko": "constructor 다음 방향마다 증명하세요. not_or_iff 의 왼쪽에서 오른쪽: ⟨fun hp => h (Or.inl hp), fun hq => h (Or.inr hq)⟩. 오른쪽에서 왼쪽: intro ⟨hnp, hnq⟩ h 다음 h 로 경우 나누기. iff_use: h.mpr hq.",
		},
	},
	{
		Name:   "043_forall",
		Expect: fill().without(logic...),
		Broken: blank("theorem all_imp"),
		Hint: L{
			"en": "all_imp: intro x, exact h1 x (h2 x). two_instances: ⟨h 5, h 7⟩. forall_and_split: intro h, exact ⟨fun x => (h x).1, fun x => (h x).2⟩. even_add_two: h 4 even_four.",
			"ko": "all_imp: intro x, exact h1 x (h2 x). two_instances: ⟨h 5, h 7⟩. forall_and_split: intro h, exact ⟨fun x => (h x).1, fun x => (h x).2⟩. even_add_two: h 4 even_four.",
		},
	},
	{
		Name:   "044_exists",
		Expect: fill().without(logic...),
		Broken: blank("theorem square_49"),
		Hint: L{
			"en": "square_49: ⟨7, rfl⟩. exists_map: intro ⟨x, hx⟩, exact ⟨x, h x hx⟩. not_exists_iff: constructor; left to right, intro h x hx, exact h ⟨x, hx⟩; right to left, intro h ⟨x, hx⟩, exact h x hx.",
			"ko": "square_49: ⟨7, rfl⟩. exists_map: intro ⟨x, hx⟩, exact ⟨x, h x hx⟩. not_exists_iff: constructor 다음, 왼쪽에서 오른쪽은 intro h x hx, exact h ⟨x, hx⟩, 오른쪽에서 왼쪽은 intro h ⟨x, hx⟩, exact h x hx.",
		},
	},
	{
		Name:   "045_rewrite",
		Expect: fill().without(logic...),
		Broken: blank("theorem eq_chain"),
		Hint: L{
			"en": "eq_chain: rw [h1, h2]. plus_zero: rw [Nat.add_zero, h]. apply_both: rw [h]. reverse_sum: rw [Nat.add_comm (a + b) c, Nat.add_comm a b, Nat.add_assoc]. undo_succ: rw [← h, Nat.add_sub_cancel].",
			"ko": "eq_chain: rw [h1, h2]. plus_zero: rw [Nat.add_zero, h]. apply_both: rw [h]. reverse_sum: rw [Nat.add_comm (a + b) c, Nat.add_comm a b, Nat.add_assoc]. undo_succ: rw [← h, Nat.add_sub_cancel].",
		},
	},
	{
		Name:   "046_calc",
		Expect: fill().without(logic...),
		Broken: blank("theorem lt_chain"),
		Hint: L{
			"en": "lt_chain: calc a = b := h1, then _ ≤ c := h2 and _ < d := h3. double_double: calc a + a = 2 * b + 2 * b := by rw [h], then _ = (2 + 2) * b := (Nat.add_mul 2 2 b).symm, then _ = 4 * b := rfl.",
			"ko": "lt_chain: calc a = b := h1 다음 _ ≤ c := h2, _ < d := h3. double_double: calc a + a = 2 * b + 2 * b := by rw [h] 다음 _ = (2 + 2) * b := (Nat.add_mul 2 2 b).symm, 그다음 _ = 4 * b := rfl.",
		},
	},
	{
		Name:   "047_classical",
		Expect: fill().without(logic...),
		Broken: blank("theorem excluded_middle"),
		Hint: L{
			"en": "excluded_middle: Classical.em p. double_neg_elim: intro hnn, by_cases hp : p; the second case is absurd hp hnn. In not_and_iff and imp_iff_or, the direction toward ∨ needs by_cases hp : p.",
			"ko": "excluded_middle: Classical.em p. double_neg_elim: intro hnn, by_cases hp : p. 둘째 경우는 absurd hp hnn. not_and_iff 와 imp_iff_or 에서 ∨ 로 가는 방향에 by_cases hp : p 가 필요합니다.",
		},
	},
	{
		Name:   "048_quiz4",
		Expect: fill().without(logic...),
		Broken: blank("theorem or_and_distrib"),
		Hint: L{
			"en": "or_and_distrib, right to left: rcases on p ∨ q; when q holds, rcases on p ∨ r too. exists_forall_swap: intro ⟨x, hx⟩ y, exact ⟨x, hx y⟩. forall_not_exists: h x hx. iff_trans': a pair of functions built from .mp and .mpr.",
			"ko": "or_and_distrib 의 오른쪽에서 왼쪽: p ∨ q 로 rcases 하고, q 일 때는 p ∨ r 로도 rcases. exists_forall_swap: intro ⟨x, hx⟩ y, exact ⟨x, hx y⟩. forall_not_exists: h x hx. iff_trans': .mp 와 .mpr 로 만든 함수 한 쌍.",
		},
	},

	// Part 5: induction. Proofs about recursive functions defined in the exercise, so that the
	// library's theorems about List and Nat do not apply. 049-052 by hand (logic); from 053 on,
	// simp and omega are accepted (search).
	{
		Name:   "049_induction",
		Expect: fill().without(logic...),
		Broken: blank("theorem zero_add'"),
		Hint: L{
			"en": "zero_add': induction n with | zero => rfl | succ n ih => rw [add_succ', ih]. succ_add' is the same, with rw [add_succ', add_succ', ih]. add_comm': induction n; zero: rw [add_zero', zero_add']; succ: rw [add_succ', succ_add', ih].",
			"ko": "zero_add': induction n with | zero => rfl | succ n ih => rw [add_succ', ih]. succ_add' 도 같고, rw [add_succ', add_succ', ih]. add_comm': induction n 다음 zero 는 rw [add_zero', zero_add'], succ 는 rw [add_succ', succ_add', ih].",
		},
	},
	{
		Name:   "050_lists",
		Expect: fill().without(logic...),
		Broken: blank("theorem append_nil"),
		Hint: L{
			"en": "append_nil: induction xs with | nil => rfl | cons x xs ih => rw [append, ih]. append_assoc: rw [append, append, append, ih] in the cons case. len_append: nil, rw [append, len, Nat.zero_add]; cons, rw [append, len, len, ih, Nat.add_right_comm].",
			"ko": "append_nil: induction xs with | nil => rfl | cons x xs ih => rw [append, ih]. append_assoc: cons 경우에 rw [append, append, append, ih]. len_append: nil 은 rw [append, len, Nat.zero_add], cons 는 rw [append, len, len, ih, Nat.add_right_comm].",
		},
	},
	{
		Name:   "051_map",
		Expect: fill().without(logic...),
		Broken: blank("theorem map_id'"),
		Hint: L{
			"en": "Induction on xs, nil by rfl. cons: map_id', rw [map, ih]; map_map, rw [map, map, map, ih]; map_append, rw [append, map, map, append, ih].",
			"ko": "xs 에 대한 귀납, nil 은 rfl. cons: map_id' 는 rw [map, ih], map_map 은 rw [map, map, map, ih], map_append 는 rw [append, map, map, append, ih].",
		},
	},
	{
		Name:   "052_lemmas",
		Expect: fill().without(logic...),
		Broken: blank("theorem reverse_append"),
		Hint: L{
			"en": "reverse_append: induction xs; nil, rw [append, reverse, append_nil]; cons, rw [append, reverse, reverse, ih, append_assoc]. reverse_reverse: cons, rw [reverse, reverse_append, ih], then rfl.",
			"ko": "reverse_append: xs 에 대한 귀납. nil 은 rw [append, reverse, append_nil], cons 는 rw [append, reverse, reverse, ih, append_assoc]. reverse_reverse: cons 는 rw [reverse, reverse_append, ih] 다음 rfl.",
		},
	},
	{
		Name:   "053_simp_omega",
		Expect: fill().without(search...),
		Broken: blank("theorem shuffle"),
		Hint: L{
			"en": "shuffle and reverse_sum: omega. len_append: induction xs; nil, simp [append, len]; cons, simp [append, len, ih]; omega. append_nil: induction xs <;> simp [append, *]. len_append_nil: simp.",
			"ko": "shuffle 과 reverse_sum: omega. len_append: xs 에 대한 귀납. nil 은 simp [append, len], cons 는 simp [append, len, ih]; omega. append_nil: induction xs <;> simp [append, *]. len_append_nil: simp.",
		},
	},
	{
		Name:   "054_generalizing",
		Expect: fill().without(search...),
		Broken: blank("theorem sumAcc_eq"),
		Hint: L{
			"en": "sumAcc_eq: induction xs generalizing acc; nil, simp [sumAcc, sum]; cons, simp [sumAcc, sum, ih]; omega. sumTR_eq: simp [sumTR, sumAcc_eq]. revAcc_eq: induction xs generalizing acc, then simp [revAcc, ih] in the cons case.",
			"ko": "sumAcc_eq: induction xs generalizing acc. nil 은 simp [sumAcc, sum], cons 는 simp [sumAcc, sum, ih]; omega. sumTR_eq: simp [sumTR, sumAcc_eq]. revAcc_eq: induction xs generalizing acc 다음 cons 경우에 simp [revAcc, ih].",
		},
	},
	{
		Name:   "055_trees",
		Expect: fill().without(search...),
		Broken: blank("theorem mirror_mirror"),
		Hint: L{
			"en": "induction t with | leaf => rfl | node l v r ihl ihr => simp [mirror, ihl, ihr]. Add size or toList to the simp list for the other two, and omega after it for size_mirror.",
			"ko": "induction t with | leaf => rfl | node l v r ihl ihr => simp [mirror, ihl, ihr]. 나머지 둘은 simp 목록에 size 나 toList 를 더하고, size_mirror 는 그 뒤에 omega.",
		},
	},
	{
		Name:   "056_fun_induction",
		Expect: fill().without(search...),
		Broken: blank("theorem evens_le"),
		Hint: L{
			"en": "fun_induction evens xs with | case1 => simp | case2 x => simp | case3 x y xs ih => simp; omega. The same works for evens_half.",
			"ko": "fun_induction evens xs with | case1 => simp | case2 x => simp | case3 x y xs ih => simp; omega. evens_half 도 같은 방법으로 됩니다.",
		},
	},
	{
		Name:   "057_quiz5",
		Expect: fill().without(search...),
		Broken: blank("theorem eval_addS"),
		Hint: L{
			"en": "eval_addS: unfold addS, then split <;> simp [eval]; the same for eval_mulS. simplify_correct: induction e; num, rfl; add, rw [simplify, eval_addS, iha, ihb, eval]; mul, the same with eval_mulS.",
			"ko": "eval_addS: unfold addS 다음 split <;> simp [eval]. eval_mulS 도 같습니다. simplify_correct: e 에 대한 귀납. num 은 rfl, add 는 rw [simplify, eval_addS, iha, ihb, eval], mul 은 eval_mulS 로 같게.",
		},
	},

	// Part 6: dependent types. Proofs inside programs: index proofs, Fin, length-indexed vectors,
	// subtypes, termination proofs, invariants and Decidable instances.
	{
		Name:   "058_indices",
		Expect: fix().without(search...),
		Broken: Broken{Contains: "failed to prove index is valid", At: "def third"},
		Hint: L{
			"en": "Give third a hypothesis: def third (xs : Array Nat) (h : 2 < xs.size) : Nat := xs[2]. Fin 5 counts modulo 5: 3 + 4 is 7, which is 2. Fin.last 4 is the largest Fin 5, 4.",
			"ko": "third 에 가정을 주세요: def third (xs : Array Nat) (h : 2 < xs.size) : Nat := xs[2]. Fin 5 는 5 로 나눈 나머지로 셉니다. 3 + 4 는 7 이고, 이는 2 입니다. Fin.last 4 는 가장 큰 Fin 5 인 4 입니다.",
		},
	},
	{
		Name:   "059_vectors",
		Expect: fix().without(search...),
		Broken: Broken{Contains: "Type mismatch", At: "| nil, ys => ys"},
		Hint: L{
			"en": "append returns Vec α (n + m): then nil gives n + 0, which computes to n, and cons gives n + (m' + 1), which computes to (n + m') + 1. map: | nil => nil | cons x xs => cons (f x) (xs.map f). zip: | nil, nil => nil | cons x xs, cons y ys => cons (x, y) (zip xs ys).",
			"ko": "append 가 Vec α (n + m) 을 돌려주게 하세요. 그러면 nil 은 n + 0 이 되어 n 으로 계산되고, cons 는 n + (m' + 1) 이 되어 (n + m') + 1 로 계산됩니다. map: | nil => nil | cons x xs => cons (f x) (xs.map f). zip: | nil, nil => nil | cons x xs, cons y ys => cons (x, y) (zip xs ys).",
		},
	},
	{
		Name:   "060_subtypes",
		Expect: fill().without(search...),
		Broken: blank("def ten"),
		Hint: L{
			"en": "ten: ⟨10, rfl⟩. addEven: ⟨a.val + b.val, by have := a.property; have := b.property; omega⟩. double: ⟨2 * n, by omega⟩. three: ⟨3, by decide⟩.",
			"ko": "ten: ⟨10, rfl⟩. addEven: ⟨a.val + b.val, by have := a.property; have := b.property; omega⟩. double: ⟨2 * n, by omega⟩. three: ⟨3, by decide⟩.",
		},
	},
	{
		Name:   "061_proof_args",
		Expect: fill().without(search...),
		Broken: blank("def firstAndLast"),
		Hint: L{
			"en": "firstAndLast: (xs.head h, xs.getLast h). second: xs[1]. middle: xs[xs.length / 2]. Lean finds the index proofs from h. secondOfLong: second xs (by omega).",
			"ko": "firstAndLast: (xs.head h, xs.getLast h). second: xs[1]. middle: xs[xs.length / 2]. Lean 이 h 로부터 인덱스 증명을 찾습니다. secondOfLong: second xs (by omega).",
		},
	},
	{
		Name:   "062_termination",
		Expect: fix().without(search...),
		Broken: Broken{Contains: "fail to show termination", At: "def euclid"},
		Hint: L{
			"en": "Write if h : b = 0 then a else euclid b (a % b), and after the definition: termination_by b, then decreasing_by exact Nat.mod_lt a (Nat.pos_of_ne_zero h).",
			"ko": "if h : b = 0 then a else euclid b (a % b) 로 쓰고, 정의 뒤에 termination_by b, 그다음 decreasing_by exact Nat.mod_lt a (Nat.pos_of_ne_zero h) 를 더하세요.",
		},
	},
	{
		Name:   "063_invariants",
		Expect: fill().without(search...),
		Broken: blank("def make"),
		Hint: L{
			"en": "make: if h : a ≤ b then ⟨a, b, h⟩ else ⟨b, a, by omega⟩. widen: ⟨r.lo, r.hi + k, by have := r.ok; omega⟩, and shift adds k to both. Theorems: have := r.ok, simp only [widen, length], omega.",
			"ko": "make: if h : a ≤ b then ⟨a, b, h⟩ else ⟨b, a, by omega⟩. widen: ⟨r.lo, r.hi + k, by have := r.ok; omega⟩, shift 는 둘 다에 k 를 더합니다. 정리: have := r.ok, simp only [widen, length], omega.",
		},
	},
	{
		Name:   "064_decidable",
		Expect: fill().without(search...),
		Broken: blank("instance (n : Nat) : Decidable (Even n)"),
		Hint: L{
			"en": "Even: inferInstanceAs (Decidable (n % 2 = 0)). isSorted follows the three cases of Sorted, with a ≤ b && isSorted (b :: rest). isSorted_iff: fun_induction isSorted xs <;> simp_all [Sorted]. The instance: fun xs => decidable_of_iff _ (isSorted_iff xs).",
			"ko": "Even: inferInstanceAs (Decidable (n % 2 = 0)). isSorted 는 Sorted 의 세 경우를 따르고 a ≤ b && isSorted (b :: rest) 를 씁니다. isSorted_iff: fun_induction isSorted xs <;> simp_all [Sorted]. instance: fun xs => decidable_of_iff _ (isSorted_iff xs).",
		},
	},
	{
		Name:   "065_quiz6",
		Expect: fill().without(search...),
		Broken: blank("def bsearch"),
		Hint: L{
			"en": "if hlt : lo < hi then (let mid := (lo + hi) / 2; if a[mid] = x then some ⟨mid, by omega⟩ else if a[mid] < x then bsearch a x (mid + 1) hi h else bsearch a x lo mid (by omega)) else none, and termination_by hi - lo after the definition.",
			"ko": "if hlt : lo < hi then (let mid := (lo + hi) / 2; if a[mid] = x then some ⟨mid, by omega⟩ else if a[mid] < x then bsearch a x (mid + 1) hi h else bsearch a x lo mid (by omega)) else none, 그리고 정의 뒤에 termination_by hi - lo.",
		},
	},

	// Part 7: verified programs. Specifications and proofs of sorting, binary search, a compiler
	// and state machines, with grind. Only the search tactics stay forbidden (suggest).
	{
		Name:   "066_grind",
		Expect: fill().without(suggest...),
		Broken: blank("theorem gauss"),
		Hint: L{
			"en": "gauss: induction n with | zero => rfl | succ n ih => grind [sumTo]. square_sum and odd_succ: grind. len_append: induction xs <;> grind [append, len].",
			"ko": "gauss: induction n with | zero => rfl | succ n ih => grind [sumTo]. square_sum 과 odd_succ: grind. len_append: induction xs <;> grind [append, len].",
		},
	},
	{
		Name:   "067_sorted",
		Expect: fill().without(suggest...),
		Broken: blank("theorem sorted_123"),
		Hint: L{
			"en": "sorted_123: .cons (by decide) (.cons (by decide) (.single 3)). not_sorted_21: intro h, then cases h with | cons h12 _ => omega. ins_sorted: induction h <;> grind [ins, Sorted.nil, Sorted.single, Sorted.cons].",
			"ko": "sorted_123: .cons (by decide) (.cons (by decide) (.single 3)). not_sorted_21: intro h 다음 cases h with | cons h12 _ => omega. ins_sorted: induction h <;> grind [ins, Sorted.nil, Sorted.single, Sorted.cons].",
		},
	},
	{
		Name:   "068_isort",
		Expect: fill().without(suggest...),
		Broken: blank("theorem isort_sorted"),
		Hint: L{
			"en": "isort_sorted: induction xs; cons, exact ins_sorted x _ ih. ins_perm: induction xs; cons, unfold ins, split, then .refl _ or (ih.cons y).trans (.swap x y ys). isort_perm: (ins_perm x _).trans (ih.cons x). badSort_not_perm: intro h, have := h.length_eq, simp [badSort] at this.",
			"ko": "isort_sorted: xs 에 대한 귀납. cons 는 exact ins_sorted x _ ih. ins_perm: xs 에 대한 귀납. cons 는 unfold ins, split 다음 .refl _ 또는 (ih.cons y).trans (.swap x y ys). isort_perm: (ins_perm x _).trans (ih.cons x). badSort_not_perm: intro h, have := h.length_eq, simp [badSort] at this.",
		},
	},
	{
		Name:   "069_bsearch",
		Expect: fill().without(suggest...),
		Broken: blank("theorem bsearch_sound"),
		Hint: L{
			"en": "bsearch_sound: fun_induction bsearch a x lo hi h with | case1 => cases hs; simp_all | case2 => simp_all | case3 => simp_all | case4 => simp at hs. find_sound: unfold find at h, cases hb : bsearch a x 0 a.size (Nat.le_refl _); none, simp [hb] at h; some j, simp [hb] at h, have := bsearch_sound a x 0 a.size (Nat.le_refl _) j hb, grind.",
			"ko": "bsearch_sound: fun_induction bsearch a x lo hi h with | case1 => cases hs; simp_all | case2 => simp_all | case3 => simp_all | case4 => simp at hs. find_sound: unfold find at h, cases hb : bsearch a x 0 a.size (Nat.le_refl _). none 은 simp [hb] at h, some j 는 simp [hb] at h, have := bsearch_sound a x 0 a.size (Nat.le_refl _) j hb, grind.",
		},
	},
	{
		Name:   "070_compiler",
		Expect: fill().without(suggest...),
		Broken: blank("theorem exec_compile"),
		Hint: L{
			"en": "exec_compile: induction e generalizing is s, then simp [compile, exec, eval] for num and simp [compile, eval, iha, ihb, exec] for add and mul. compile_correct: simpa [exec] using exec_compile e [] [].",
			"ko": "exec_compile: induction e generalizing is s 다음, num 은 simp [compile, exec, eval], add 와 mul 은 simp [compile, eval, iha, ihb, exec]. compile_correct: simpa [exec] using exec_compile e [] [].",
		},
	},
	{
		Name:   "071_invariants",
		Expect: fill().without(suggest...),
		Broken: blank("theorem bounded"),
		Hint: L{
			"en": "bounded and conserved: induction h with | init => ... | step _ hst ih => cases hst <;> simp_all <;> omega. The init case: simp [capacity] for bounded, rfl for conserved. consumed_le: have := conserved s h, then omega.",
			"ko": "bounded 와 conserved: induction h with | init => ... | step _ hst ih => cases hst <;> simp_all <;> omega. init 경우는 bounded 는 simp [capacity], conserved 는 rfl. consumed_le: have := conserved s h 다음 omega.",
		},
	},
	{
		Name:   "072_strengthening",
		Expect: fill().without(suggest...),
		Broken: blank("def LockInv"),
		Hint: L{
			"en": "LockInv s := (s.p1 = .critical → s.locked = true) ∧ (s.p2 = .critical → s.locked = true) ∧ Mutex s. lockInv_holds: induction h; init, simp [LockInv, Mutex]; step, cases hst <;> simp_all [LockInv, Mutex]. mutex: (lockInv_holds s h).2.2.",
			"ko": "LockInv s := (s.p1 = .critical → s.locked = true) ∧ (s.p2 = .critical → s.locked = true) ∧ Mutex s. lockInv_holds: h 에 대한 귀납. init 은 simp [LockInv, Mutex], step 은 cases hst <;> simp_all [LockInv, Mutex]. mutex: (lockInv_holds s h).2.2.",
		},
	},
	{
		Name:   "073_quiz7",
		Expect: fill().without(suggest...),
		Broken: blank("theorem all_insert"),
		Hint: L{
			"en": "all_insert: induction t <;> grind [insert, All]. insert_bst: induction t <;> grind [insert, BST, All, all_insert]. contains_insert: induction t <;> grind [insert, contains].",
			"ko": "all_insert: induction t <;> grind [insert, All]. insert_bst: induction t <;> grind [insert, BST, All, all_insert]. contains_insert: induction t <;> grind [insert, contains].",
		},
	},
}

// logic is what Part 4 does not accept: the tactics that would take the steps for the learner.
var logic = []string{"simp", "simp_all", "simpa", "omega", "decide", "grind", "trivial", "exact?", "apply?", "rw?", "native_decide"}

// search is what Part 5 does not accept once simp and omega are allowed: grind, which comes
// in Part 7, and the tactics that search the library for the next step.
var search = []string{"grind", "exact?", "apply?", "rw?"}

// suggest is what Part 7 does not accept: the tactics that search the library for the next step.
var suggest = []string{"exact?", "apply?", "rw?"}

// Exercise is a single exercise.
type Exercise struct {
	Name   string
	Expect Expect   // what a fixed exercise must satisfy
	Broken Broken   // how the original (unfixed) exercise should fail; used by -verify only
	Also   []Broken // further failures the original must have, e.g. one per proof to debug
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
	// Recover: the original has mistakes on purpose and still is the reference (debug()).
	// Lean compiles no file with errors, so the checker elaborates the original itself, with
	// Lean's error recovery: a proof that fails still declares its theorem, with its statement.
	Recover bool
	Output  string   // if set, what main must print (lean --run)
	Forbid  []string // tactics or names the solution must not use, e.g. omega in an exercise on induction
}

// fix is the expectation for an exercise with a mistake to fix.
func fix() Expect { return Expect{} }

// fill is the expectation for an exercise with sorrys to fill in.
func fill() Expect { return Expect{Reference: true} }

// debug is the expectation for an exercise with proofs to debug: mistakes on purpose, as with
// fix(), but the definitions and statements of the original stay, as with fill().
func debug() Expect { return Expect{Reference: true, Recover: true} }

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

// String describes b for -verify, e.g. error "Type mismatch" at "def f".
func (b Broken) String() string {
	s := b.Severity
	if s == "" {
		s = sevError
	}
	if b.Kind != "" {
		s += " " + b.Kind
	}
	if b.Contains != "" {
		s += fmt.Sprintf(" %q", b.Contains)
	}
	if b.At != "" {
		s += fmt.Sprintf(" at %q", b.At)
	}
	return s
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
