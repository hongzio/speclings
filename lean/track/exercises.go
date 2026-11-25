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
		Nudges: []L{
			{
				"en": "Read the first error Lean reports: which definition is it about, and which two types does it compare?",
				"ko": "Lean 이 보고한 첫 에러를 읽으세요. 어느 정의에 관한 것이고, 어떤 두 타입을 비교하나요?",
			},
		},
		Hint: L{
			"en": `Read the first error: "42" is a String, but answer is declared as a Nat. Numbers are written without quotes.`,
			"ko": `첫 번째 에러를 읽어 보세요. "42" 는 String 인데 answer 는 Nat 으로 선언되어 있습니다. 숫자는 따옴표 없이 씁니다.`,
		},
	},
	{
		Name:   "002_types",
		Expect: fix(),
		Broken: Broken{Contains: "Neg Nat", At: "def temperature"},
		Nudges: []L{
			{
				"en": "Each error names a type that does not fit. Can a Nat be negative? Can ++ join a String and a Nat?",
				"ko": "에러마다 맞지 않는 타입을 말해 줍니다. Nat 이 음수일 수 있나요? ++ 로 String 과 Nat 을 이을 수 있나요?",
			},
		},
		Hint: L{
			"en": `temperature is negative, so its type must be Int, not Nat. In describe, convert count with toString count, or write the whole String as s!"{name} has {count} letters".`,
			"ko": `temperature 는 음수이므로 타입이 Nat 이 아니라 Int 여야 합니다. describe 에서는 count 를 toString count 로 바꾸거나, 전체를 s!"{name} has {count} letters" 로 쓰세요.`,
		},
	},
	{
		Name:   "003_sorry",
		Expect: fill(),
		Broken: blank("def triple"),
		Nudges: []L{
			{
				"en": "Replace each sorry with an expression of the declared type; the #guard lines show what it must compute.",
				"ko": "각 sorry 를 선언된 타입의 식으로 바꾸세요. #guard 줄이 무엇을 계산해야 하는지 보여 줍니다.",
			},
		},
		Hint: L{
			"en": `triple n is n + n + n, or 3 * n. greet name is "Hello, " ++ name ++ "!", or s!"Hello, {name}!".`,
			"ko": `triple n 은 n + n + n, 또는 3 * n 입니다. greet name 은 "Hello, " ++ name ++ "!", 또는 s!"Hello, {name}!" 입니다.`,
		},
	},
	{
		Name:   "004_goals",
		Expect: fill(),
		Broken: blank("theorem two_plus_two"),
		Nudges: []L{
			{
				"en": "There are two kinds of statements here: equations that hold by computing, and comparisons that Lean can decide. The comment gives a proof for each kind.",
				"ko": "여기에는 두 종류의 명제가 있습니다. 계산하면 성립하는 등식, 그리고 Lean 이 판정할 수 있는 비교. 주석에 종류마다 증명이 하나씩 있습니다.",
			},
		},
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
		Nudges: []L{
			{
				"en": "Nat has no negative numbers and no fractions. Work out each #guard by hand, the way Lean computes on Nat.",
				"ko": "Nat 에는 음수도 분수도 없습니다. 각 #guard 를 Lean 이 Nat 에서 계산하는 방식대로 손으로 계산해 보세요.",
			},
		},
		Hint: L{
			"en": "Division rounds down and drops the remainder. A subtraction that would go below 0 gives 0, and so does dividing by 0. Evaluate the inner parentheses first.",
			"ko": "나눗셈은 내림하고 나머지를 버립니다. 0 아래로 내려가는 뺄셈은 0 이고, 0 으로 나누는 것도 0 입니다. 안쪽 괄호부터 계산하세요.",
		},
	},
	{
		Name:   "006_int",
		Expect: fix(),
		Broken: blank("#guard (-7 : Int) / 2"),
		Nudges: []L{
			{
				"en": "Int division rounds down too, toward minus infinity. In change, ask where the subtraction happens: in Nat or in Int?",
				"ko": "Int 의 나눗셈도 내림합니다. 음의 무한대 쪽으로요. change 에서는 뺄셈이 어디서 일어나는지 보세요. Nat 에서인가요, Int 에서인가요?",
			},
		},
		Hint: L{
			"en": "-7 / 2 rounds down to -4, so the remainder is 1. In change, give diff the type Int (let diff : Int := ...): then Lean converts paid and price to Int before subtracting.",
			"ko": "-7 / 2 는 -4 로 내림되므로 나머지는 1 입니다. change 에서는 diff 에 Int 타입을 주세요 (let diff : Int := ...). 그러면 Lean 이 빼기 전에 paid 와 price 를 Int 로 바꿉니다.",
		},
	},
	{
		Name:   "007_bool",
		Expect: fill(),
		Broken: blank("def isEven"),
		Nudges: []L{
			{
				"en": "Use the Bool operators &&, || and ! and the comparison ==. Say each rule in words first.",
				"ko": "Bool 연산자 &&, ||, ! 와 비교 == 를 쓰세요. 먼저 각 규칙을 말로 해 보세요.",
			},
		},
		Hint: L{
			"en": "n is even when n % 2 == 0. A leap year: divisible by 4 && (not divisible by 100 || divisible by 400).",
			"ko": "n % 2 == 0 이면 짝수입니다. 윤년: 4 로 나누어떨어지고 && (100 으로 나누어떨어지지 않거나 || 400 으로 나누어떨어짐).",
		},
	},
	{
		Name:   "008_if_let",
		Expect: fix(),
		Broken: Broken{Contains: "expected 'else'", At: "def abs"},
		Nudges: []L{
			{
				"en": "Read the parse error: in Lean, if is an expression, so it has a value in both branches.",
				"ko": "구문 에러를 읽으세요. Lean 에서 if 는 식이라서, 두 갈래 모두 값이 있어야 합니다.",
			},
		},
		Hint: L{
			"en": "abs needs an else: the value when x is not negative is x itself. For clamp, first let atLeastLo := if x < lo then lo else x, then cap it at hi the same way.",
			"ko": "abs 에는 else 가 필요합니다. x 가 음수가 아닐 때의 값은 x 그대로입니다. clamp 는 먼저 let atLeastLo := if x < lo then lo else x 로 두고, 같은 방법으로 hi 를 넘지 않게 하세요.",
		},
	},
	{
		Name:   "009_functions",
		Expect: fix(),
		Broken: Broken{Contains: "Type mismatch", At: "def square"},
		Nudges: []L{
			{
				"en": "Read the type in the error: a function given fewer arguments than it takes is itself a function, waiting for the rest.",
				"ko": "에러의 타입을 읽으세요. 받을 인자보다 적게 받은 함수는 그 자체로 나머지를 기다리는 함수입니다.",
			},
		},
		Hint: L{
			"en": "area side is still waiting for its second argument: a square has the same width and height. areaWithWidth2 is area applied to 2 only.",
			"ko": "area side 는 아직 두 번째 인자를 기다리고 있습니다. 정사각형은 가로와 세로가 같습니다. areaWithWidth2 는 area 에 2 만 준 것입니다.",
		},
	},
	{
		Name:   "010_lambdas",
		Expect: fix(),
		Broken: Broken{Contains: "expected '↦', '=>'", At: "def doubled"},
		Nudges: []L{
			{
				"en": "The error is at the arrow of an anonymous function: see the comment for how Lean writes one.",
				"ko": "에러는 익명 함수의 화살표에 있습니다. Lean 이 어떻게 쓰는지 주석을 보세요.",
			},
		},
		Hint: L{
			"en": "Lean writes fun x => ..., not ->. twice f x is f (f x). compose g f is fun x => g (f x).",
			"ko": "Lean 은 -> 가 아니라 fun x => ... 로 씁니다. twice f x 는 f (f x) 입니다. compose g f 는 fun x => g (f x) 입니다.",
		},
	},
	{
		Name:   "011_match",
		Expect: fix(),
		Broken: Broken{Contains: "Missing cases", At: `| 0 => "none"`},
		Nudges: []L{
			{
				"en": "Lean says which cases are missing. A match must cover every value; a case with _ catches the rest.",
				"ko": "Lean 이 어떤 경우가 빠졌는지 말해 줍니다. match 는 모든 값을 다뤄야 하고, _ 인 경우가 나머지를 받습니다.",
			},
		},
		Hint: L{
			"en": `Add a last case | _ => "many" to size. minusTwo has three cases: 0, 1, and n + 2.`,
			"ko": `size 에 마지막 경우 | _ => "many" 를 더하세요. minusTwo 는 0, 1, n + 2 의 세 경우입니다.`,
		},
	},
	{
		Name:   "012_recursion",
		Expect: fix(),
		Broken: Broken{Contains: "fail to show termination", At: "def sumTo"},
		Nudges: []L{
			{
				"en": "Lean cannot see that sumTo stops. Look at the argument of the call to itself: is it smaller?",
				"ko": "Lean 은 sumTo 가 멈춘다는 것을 알지 못합니다. 자기 자신을 부를 때의 인자를 보세요. 더 작아지나요?",
			},
		},
		Hint: L{
			"en": "sumTo (n + 1) calls itself on the same argument, so it never stops: call it on n. fib has three cases: 0, 1, and n + 2, which is fib n + fib (n + 1).",
			"ko": "sumTo (n + 1) 은 같은 인자로 자신을 불러서 끝나지 않습니다. n 으로 부르세요. fib 는 0, 1, n + 2 의 세 경우이고, n + 2 는 fib n + fib (n + 1) 입니다.",
		},
	},
	{
		Name:   "013_lists",
		Expect: fill().without("length", "sum", "contains", "elem", "foldl", "foldr", "any"),
		Broken: blank("def len"),
		Nudges: []L{
			{
				"en": "A list is [] or x :: xs. Write one case for each, and in the second call the function on xs.",
				"ko": "리스트는 [] 이거나 x :: xs 입니다. 각각에 한 경우를 쓰고, 둘째 경우에서 xs 에 대해 함수를 부르세요.",
			},
		},
		Hint: L{
			"en": "Each has two cases. len: [] is 0, and _ :: xs is 1 + len xs. total is similar. has: match xs with | [] => false | x :: rest => x == y || has rest y.",
			"ko": "모두 두 경우입니다. len: [] 는 0, _ :: xs 는 1 + len xs. total 도 비슷합니다. has: match xs with | [] => false | x :: rest => x == y || has rest y.",
		},
	},
	{
		Name:   "014_list_functions",
		Expect: fill(),
		Broken: blank("def squares"),
		Nudges: []L{
			{
				"en": "Build each from List.range, map, filter and foldl, as in the comment; no recursion is needed.",
				"ko": "주석처럼 List.range, map, filter, foldl 로 만드세요. 재귀는 필요 없습니다.",
			},
		},
		Hint: L{
			"en": "squares: map (· ^ 2) over List.range n. evens: filter. product: foldl with (· * ·), starting from 1. sumOfOddSquares: range, then filter, map and foldl.",
			"ko": "squares: List.range n 에 map (· ^ 2). evens: filter. product: 1 에서 시작하는 (· * ·) 의 foldl. sumOfOddSquares: range 다음에 filter, map, foldl.",
		},
	},
	{
		Name:   "015_option",
		Expect: fix(),
		Broken: Broken{Contains: "Type mismatch", At: "def first"},
		Nudges: []L{
			{
				"en": "first is declared to return an Option Nat, so that [] has an answer too, but xs.head is not one: look for the variant of head that returns an Option.",
				"ko": "first 는 [] 에도 답이 있도록 Option Nat 을 돌려준다고 선언되어 있는데, xs.head 는 그렇지 않습니다. Option 을 돌려주는 head 를 찾으세요.",
			},
		},
		Hint: L{
			"en": "first is xs.head?. firstOr: (first xs).getD fallback. safeDiv: if b == 0 then none else some (a / b).",
			"ko": "first 는 xs.head? 입니다. firstOr: (first xs).getD fallback. safeDiv: if b == 0 then none else some (a / b).",
		},
	},
	{
		Name:   "016_pairs",
		Expect: fill(),
		Broken: blank("def divMod"),
		Nudges: []L{
			{
				"en": "A pair is written (a, b), and .1 and .2 take it apart. For indexed, pair each index with its element.",
				"ko": "쌍은 (a, b) 로 쓰고, .1 과 .2 로 꺼냅니다. indexed 는 각 인덱스를 그 원소와 짝지으세요.",
			},
		},
		Hint: L{
			"en": "divMod a b is (a / b, a % b). swap p is (p.2, p.1). sumPairs maps fun (a, b) => a + b. indexed zips List.range xs.length with xs.",
			"ko": "divMod a b 는 (a / b, a % b), swap p 는 (p.2, p.1) 입니다. sumPairs 는 fun (a, b) => a + b 로 map 합니다. indexed 는 List.range xs.length 와 xs 를 zip 합니다.",
		},
	},
	{
		Name:   "017_quiz1",
		Expect: fill(),
		Broken: blank("def digits"),
		Nudges: []L{
			{
				"en": "digits: the last digit is n % 10 and the rest is n / 10; stop below 10. fizzbuzz: test the most specific case first.",
				"ko": "digits: 마지막 자리는 n % 10 이고 나머지는 n / 10 입니다. 10 보다 작으면 멈추세요. fizzbuzz: 가장 구체적인 경우부터 검사하세요.",
			},
		},
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
		Nudges: []L{
			{
				"en": "The error lists the missing fields: a structure value needs all of them. { p with ... } copies p and changes some.",
				"ko": "에러가 빠진 필드를 알려 줍니다. 구조체 값에는 모든 필드가 필요합니다. { p with ... } 는 p 를 복사하고 일부를 바꿉니다.",
			},
		},
		Hint: L{
			"en": "origin needs both fields: { x := 0, y := 0 }. moveRight: { p with x := p.x + dx }. add: ⟨p.x + q.x, p.y + q.y⟩.",
			"ko": "origin 에는 두 필드가 모두 필요합니다: { x := 0, y := 0 }. moveRight: { p with x := p.x + dx }. add: ⟨p.x + q.x, p.y + q.y⟩.",
		},
	},
	{
		Name:   "019_deriving",
		Expect: fix(),
		Broken: Broken{Contains: "BEq Point", At: "#guard p == ⟨1, 2⟩"},
		Nudges: []L{
			{
				"en": "== needs an instance of BEq for Point, and #eval one of Repr. Lean can derive both for a structure.",
				"ko": "== 에는 Point 의 BEq 인스턴스가, #eval 에는 Repr 인스턴스가 필요합니다. 구조체라면 Lean 이 둘 다 만들어 줄 수 있습니다.",
			},
		},
		Hint: L{
			"en": "Add the line deriving BEq, Repr at the end of the structure, indented like the fields. swapXY p is ⟨p.y, p.x⟩.",
			"ko": "structure 끝에 필드와 같은 들여쓰기로 deriving BEq, Repr 줄을 더하세요. swapXY p 는 ⟨p.y, p.x⟩ 입니다.",
		},
	},
	{
		Name:   "020_enums",
		Expect: fill(),
		Broken: blank("def isWeekend"),
		Nudges: []L{
			{
				"en": "Match on the constructors, .saturday, .sunday and so on; a case with _ covers the rest.",
				"ko": ".saturday, .sunday 같은 생성자로 match 하세요. _ 인 경우가 나머지를 다룹니다.",
			},
		},
		Hint: L{
			"en": "isWeekend: | .saturday | .sunday => true and | _ => false. next has one case per day, and .sunday goes back to .monday.",
			"ko": "isWeekend: | .saturday | .sunday => true 와 | _ => false. next 는 요일마다 한 경우이고, .sunday 다음은 다시 .monday 입니다.",
		},
	},
	{
		Name:   "021_inductive_data",
		Expect: fill(),
		Broken: blank("def area"),
		Nudges: []L{
			{
				"en": "One case per constructor of Shape, each naming the fields it carries.",
				"ko": "Shape 의 생성자마다 한 경우를 쓰고, 각 경우에서 그 생성자가 가진 필드에 이름을 붙이세요.",
			},
		},
		Hint: L{
			"en": "Match with one case per constructor: | .square s => ... | .rect w h => ... | .triangle b h => .... A triangle's area is b * h / 2. In isSquare, a rectangle is a square when w == h.",
			"ko": "생성자마다 한 경우로 match 하세요: | .square s => ... | .rect w h => ... | .triangle b h => .... 삼각형의 넓이는 b * h / 2 입니다. isSquare 에서 직사각형은 w == h 일 때 정사각형입니다.",
		},
	},
	{
		Name:   "022_trees",
		Expect: fill(),
		Broken: blank("def size"),
		Nudges: []L{
			{
				"en": "Each function has a case for .leaf and one for .node l v r, which calls the function on l and r.",
				"ko": "함수마다 .leaf 경우와 .node l v r 경우가 있고, 뒤의 것은 l 과 r 에 대해 함수를 부릅니다.",
			},
		},
		Hint: L{
			"en": "Two cases each, | .leaf => ... and | .node l v r => .... size: size l + 1 + size r. depth: 1 + max (depth l) (depth r). mirror swaps l and r, mirroring both. toList: toList l ++ [v] ++ toList r.",
			"ko": "모두 | .leaf => ... 와 | .node l v r => ... 의 두 경우입니다. size: size l + 1 + size r. depth: 1 + max (depth l) (depth r). mirror 는 l 과 r 을 바꾸고 둘 다 mirror 합니다. toList: toList l ++ [v] ++ toList r.",
		},
	},
	{
		Name:   "023_expressions",
		Expect: fill(),
		Broken: blank("def eval"),
		Nudges: []L{
			{
				"en": "eval and render: one case per constructor, recursing into the subexpressions. simplify: simplify the parts first, then look at what they became.",
				"ko": "eval 과 render: 생성자마다 한 경우이고, 부분식으로 재귀합니다. simplify: 부분을 먼저 단순화하고, 그 결과를 보세요.",
			},
		},
		Hint: L{
			"en": `eval: | .add a b => eval a + eval b, and the same for mul. render: s!"({render a} + {render b})". simplify (.add a b): match simplify a, simplify b with | .num 0, b' => b' | a', .num 0 => a' | a', b' => .add a' b', and the same with 1 for mul.`,
			"ko": `eval: | .add a b => eval a + eval b, mul 도 같은 식입니다. render: s!"({render a} + {render b})". simplify (.add a b): match simplify a, simplify b with | .num 0, b' => b' | a', .num 0 => a' | a', b' => .add a' b', mul 은 1 로 같은 식입니다.`,
		},
	},
	{
		Name:   "024_polymorphism",
		Expect: fill(),
		Broken: blank("def swap"),
		Nudges: []L{
			{
				"en": "These work for every type α, so they cannot look inside its values: they can only move them around, or apply f.",
				"ko": "이 함수들은 모든 타입 α 에 대해 동작하므로 값의 안을 볼 수 없습니다. 옮기거나 f 를 적용할 수만 있습니다.",
			},
		},
		Hint: L{
			"en": "swap p is (p.2, p.1). mapOption: | none => none | some x => some (f x). mapTree: | .leaf => .leaf | .node l v r => .node (mapTree f l) (f v) (mapTree f r).",
			"ko": "swap p 는 (p.2, p.1) 입니다. mapOption: | none => none | some x => some (f x). mapTree: | .leaf => .leaf | .node l v r => .node (mapTree f l) (f v) (mapTree f r).",
		},
	},
	{
		Name:   "025_namespaces",
		Expect: fix(),
		Broken: Broken{Contains: "Invalid field", At: "#guard sample.size"},
		Nudges: []L{
			{
				"en": "Read the error: sample.size looks for a function Tree.size, in the namespace of the type of sample.",
				"ko": "에러를 읽으세요. sample.size 는 sample 의 타입 이름공간에서 Tree.size 를 찾습니다.",
			},
		},
		Hint: L{
			"en": "Rename size to Tree.size (def Tree.size ...); inside it, size still refers to itself. sum: | leaf => 0 | node l v r => sum l + v + sum r.",
			"ko": "size 의 이름을 Tree.size 로 바꾸세요 (def Tree.size ...). 그 안에서 size 는 여전히 자기 자신입니다. sum: | leaf => 0 | node l v r => sum l + v + sum r.",
		},
	},
	{
		Name:   "026_instances",
		Expect: fix(),
		Broken: Broken{Contains: "HAdd Point Point", At: "def shift"},
		Nudges: []L{
			{
				"en": "The error says that Lean has no + for Point: give it one with an instance of Add. ToString works the same way.",
				"ko": "에러는 Point 에 + 가 없다고 말합니다. Add 인스턴스로 만들어 주세요. ToString 도 같은 방식입니다.",
			},
		},
		Hint: L{
			"en": `Before shift: instance : Add Point where add p q := ⟨p.x + q.x, p.y + q.y⟩. toString p is s!"({p.x}, {p.y})".`,
			"ko": `shift 앞에: instance : Add Point where add p q := ⟨p.x + q.x, p.y + q.y⟩. toString p 는 s!"({p.x}, {p.y})" 입니다.`,
		},
	},
	{
		Name:   "027_classes",
		Expect: fix(),
		Broken: Broken{Contains: "BEq α", At: "def count"},
		Nudges: []L{
			{
				"en": "count compares with ==, so it needs an instance of BEq for α: ask for one among its arguments.",
				"ko": "count 는 == 로 비교하므로 α 의 BEq 인스턴스가 필요합니다. 인자로 요구하세요.",
			},
		},
		Hint: L{
			"en": `Add [BEq α] after {α : Type} in count. describe n is s!"the number {n}". describeAll maps Describe.describe. The list instance: "[" ++ ", ".intercalate (describeAll xs) ++ "]".`,
			"ko": `count 의 {α : Type} 다음에 [BEq α] 를 더하세요. describe n 은 s!"the number {n}" 입니다. describeAll 은 Describe.describe 로 map 합니다. 리스트 instance: "[" ++ ", ".intercalate (describeAll xs) ++ "]".`,
		},
	},
	{
		Name:   "028_quiz2",
		Expect: fill(),
		Broken: blank("def insert"),
		Nudges: []L{
			{
				"en": "In a binary search tree, smaller values go left and larger ones right. insert and contains follow the same path down.",
				"ko": "이진 탐색 트리에서 작은 값은 왼쪽, 큰 값은 오른쪽으로 갑니다. insert 와 contains 는 같은 길을 따라 내려갑니다.",
			},
		},
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
		Nudges: []L{
			{
				"en": "Read the type mismatch: what is the type of IO.println greeting, and what is main declared as?",
				"ko": "타입 불일치를 읽으세요. IO.println greeting 의 타입은 무엇이고, main 은 무엇으로 선언되어 있나요?",
			},
		},
		Hint: L{
			"en": "IO.println greeting is an action of type IO Unit, so main must have that type: def main : IO Unit := ...",
			"ko": "IO.println greeting 은 IO Unit 타입의 동작이므로 main 도 그 타입이어야 합니다: def main : IO Unit := ...",
		},
	},
	{
		Name:   "030_do",
		Expect: fix().prints("Rolling...\nYou rolled 4, plus one is 5.\n"),
		Broken: Broken{Contains: "ToString (IO Nat)", At: "You rolled"},
		Nudges: []L{
			{
				"en": "The error is about printing an IO Nat: an action, not the Nat it produces. In do, ← runs an action.",
				"ko": "에러는 IO Nat 을 출력하려는 데 있습니다. 그것은 Nat 이 아니라 Nat 을 만드는 행동입니다. do 안에서 ← 가 행동을 실행합니다.",
			},
		},
		Hint: L{
			"en": "let n := roll names the action. let n ← roll runs it, and n is the Nat it gives.",
			"ko": "let n := roll 은 동작에 이름만 붙입니다. let n ← roll 은 동작을 실행하고, n 은 그 결과인 Nat 입니다.",
		},
	},
	{
		Name:   "031_mut_for",
		Expect: fix().prints("3\n2\n1\nliftoff!\n"),
		Broken: Broken{Contains: "cannot be mutated", At: "sum := sum + x"},
		Nudges: []L{
			{
				"en": "The error says that sum cannot be mutated: a variable that a loop assigns to must be declared mutable.",
				"ko": "에러는 sum 을 바꿀 수 없다고 말합니다. 반복문에서 값을 다시 넣는 변수는 바꿀 수 있게 선언해야 합니다.",
			},
		},
		Hint: L{
			"en": `Declare sum with let mut. countdown: Id.run do, let mut lines := [], then for i in List.range n do lines := toString (i + 1) :: lines, and return lines ++ ["liftoff!"].`,
			"ko": `sum 을 let mut 으로 선언하세요. countdown: Id.run do 안에서 let mut lines := [], 그다음 for i in List.range n do lines := toString (i + 1) :: lines, 마지막에 return lines ++ ["liftoff!"].`,
		},
	},
	{
		Name:   "032_arrays",
		Expect: fill(),
		Broken: blank("def squaresArray"),
		Nudges: []L{
			{
				"en": "Build arrays with push in a for loop inside Id.run do. a[i]? gives an Option, since i may be out of range.",
				"ko": "배열은 Id.run do 안의 for 반복문에서 push 로 만듭니다. i 가 범위를 벗어날 수 있으므로 a[i]? 는 Option 을 줍니다.",
			},
		},
		Hint: L{
			"en": "squaresArray: Id.run do with let mut out := #[] and out := out.push (i * i) in a for loop. get: a[i]?.getD 0. histogram: start from Array.replicate buckets 0 and modify x (· + 1) for every x < buckets.",
			"ko": "squaresArray: Id.run do 안에서 let mut out := #[] 로 시작해, for 반복에서 out := out.push (i * i). get: a[i]?.getD 0. histogram: Array.replicate buckets 0 에서 시작해, buckets 보다 작은 x 마다 modify x (· + 1).",
		},
	},
	{
		Name:   "033_except",
		Expect: fill(),
		Broken: blank("def parseAge"),
		Nudges: []L{
			{
				"en": "Except String Nat is a Nat or an error message: throw makes the error, pure the value, and ← in do stops at the first error.",
				"ko": "Except String Nat 은 Nat 이거나 에러 메시지입니다. throw 는 에러를, pure 는 값을 만들고, do 안의 ← 는 첫 에러에서 멈춥니다.",
			},
		},
		Hint: L{
			"en": `parseAge: match s.toNat? with | none => throw s!"not a number: {s}" | some n => if n > 150 then throw s!"too old: {n}" else pure n. averageAge: do, let x ← parseAge a, the same for b, return (x + y) / 2. parseAll: xs.mapM parseAge.`,
			"ko": `parseAge: match s.toNat? with | none => throw s!"not a number: {s}" | some n => if n > 150 then throw s!"too old: {n}" else pure n. averageAge: do 안에서 let x ← parseAge a, b 도 같게, return (x + y) / 2. parseAll: xs.mapM parseAge.`,
		},
	},
	{
		Name:   "034_strings",
		Expect: fill(),
		Broken: blank("def wordCount"),
		Nudges: []L{
			{
				"en": "Split the String into words, then use the List functions of 014 on the pieces.",
				"ko": "String 을 단어로 나눈 다음, 그 조각들에 014 의 List 함수들을 쓰세요.",
			},
		},
		Hint: L{
			"en": `wordCount: split on " ", filter out the empty Strings, take the length. sumNumbers: split, filterMap String.toNat?, foldl. onlyDigits: String.ofList of the filtered toList. titleCase: " ".intercalate of the capitalized words.`,
			"ko": `wordCount: " " 로 나누고, 빈 String 을 걸러 내고, 길이를 셉니다. sumNumbers: 나누고, String.toNat? 로 filterMap, foldl. onlyDigits: toList 를 거른 것의 String.ofList. titleCase: capitalize 한 단어들을 " ".intercalate.`,
		},
	},
	{
		Name:   "035_partial",
		Expect: fix(),
		Broken: Broken{Contains: "fail to show termination", At: "def collatz"},
		Nudges: []L{
			{
				"en": "Nobody knows whether collatz stops for every n, so it cannot be proved to Lean. Lean accepts such a function when you mark it.",
				"ko": "collatz 가 모든 n 에 대해 멈추는지는 아무도 모르므로 Lean 에게 증명할 수 없습니다. 그런 함수는 표시를 해 두면 Lean 이 받아들입니다.",
			},
		},
		Hint: L{
			"en": "Write partial def collatz. longestBelow: Id.run do, let mut best := 0, and for i in List.range n, take i when collatz i > collatz best.",
			"ko": "partial def collatz 로 쓰세요. longestBelow: Id.run do 안에서 let mut best := 0, for i in List.range n 에서 collatz i > collatz best 이면 i 로 바꿉니다.",
		},
	},
	{
		Name:   "036_quiz3",
		Expect: fill().prints("the: 3\ncat: 1\nsat: 1\non: 1\nmat: 1\nend: 1\n"),
		Broken: blank("def countWords"),
		Nudges: []L{
			{
				"en": "countWords: go through the words with a list of (word, count) pairs; when a word is already there, add one to its count. main: print a line per pair in a for loop.",
				"ko": "countWords: (단어, 개수) 쌍의 리스트를 들고 단어들을 훑습니다. 이미 있는 단어면 개수에 1 을 더합니다. main: for 반복문으로 쌍마다 한 줄씩 출력하세요.",
			},
		},
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
		Nudges: []L{
			{
				"en": "To prove p → q, assume p and prove q: intro, or fun hp => .... To use h : p → q, apply it to a proof of p, like a function.",
				"ko": "p → q 를 증명하려면 p 를 가정하고 q 를 증명합니다: intro, 또는 fun hp => .... h : p → q 를 쓰려면 함수처럼 p 의 증명에 적용합니다.",
			},
		},
		Hint: L{
			"en": "self_imp: fun hp => hp. modus_ponens: hpq hp. imp_trans: intro hp, then exact hqr (hpq hp). const_imp: intro hp _, then exact hp.",
			"ko": "self_imp: fun hp => hp. modus_ponens: hpq hp. imp_trans: intro hp 다음 exact hqr (hpq hp). const_imp: intro hp _ 다음 exact hp.",
		},
	},
	{
		Name:   "038_apply",
		Expect: fill().without(logic...),
		Broken: blank("theorem chain"),
		Nudges: []L{
			{
				"en": "apply h works backwards: when h proves the goal from premises, the premises become the new goals.",
				"ko": "apply h 는 거꾸로 갑니다. h 가 전제들로부터 목표를 증명한다면, 그 전제들이 새 목표가 됩니다.",
			},
			{
				"en": "chain: start with the hypothesis whose conclusion is the goal, then the one that gives its premise, and so on.",
				"ko": "chain: 결론이 목표인 가정부터 apply 하고, 그다음 그 전제를 주는 가정, 이런 식으로 갑니다.",
			},
		},
		Hint: L{
			"en": "chain: apply h3, apply h2, apply h1, exact hp. two_premises: apply h leaves the goals p and q; close each with assumption. pick: apply h, then assumption.",
			"ko": "chain: apply h3, apply h2, apply h1, exact hp. two_premises: apply h 는 목표 p 와 q 를 남기니 각각 assumption 으로 닫으세요. pick: apply h 다음 assumption.",
		},
	},
	{
		Name:   "039_and",
		Expect: fill().without(logic...),
		Broken: blank("theorem and_swap"),
		Nudges: []L{
			{
				"en": "A proof of p ∧ q is a pair ⟨hp, hq⟩. h.1 and h.2 take one apart, and obtain ⟨hp, hq⟩ := h names both parts.",
				"ko": "p ∧ q 의 증명은 쌍 ⟨hp, hq⟩ 입니다. h.1 과 h.2 로 꺼내고, obtain ⟨hp, hq⟩ := h 로 두 부분에 이름을 붙입니다.",
			},
			{
				"en": "curry and uncurry turn a function of a pair into a function of two arguments, and back: intro what the goal offers, then build the pair or take it apart.",
				"ko": "curry 와 uncurry 는 쌍을 받는 함수를 인자 둘을 받는 함수로, 또 그 반대로 바꿉니다. 목표가 주는 것을 intro 한 다음 쌍을 만들거나 푸세요.",
			},
		},
		Hint: L{
			"en": "and_swap: intro h, exact ⟨h.2, h.1⟩. and_assoc_mp: intro h, obtain ⟨⟨hp, hq⟩, hr⟩ := h, exact ⟨hp, hq, hr⟩. curry: intro h hp hq, exact h ⟨hp, hq⟩. uncurry: intro h hpq, exact h hpq.1 hpq.2.",
			"ko": "and_swap: intro h, exact ⟨h.2, h.1⟩. and_assoc_mp: intro h, obtain ⟨⟨hp, hq⟩, hr⟩ := h, exact ⟨hp, hq, hr⟩. curry: intro h hp hq, exact h ⟨hp, hq⟩. uncurry: intro h hpq, exact h hpq.1 hpq.2.",
		},
	},
	{
		Name:   "040_or",
		Expect: fill().without(logic...),
		Broken: blank("theorem or_swap"),
		Nudges: []L{
			{
				"en": "To prove p ∨ q, choose a side: left or right. To use h : p ∨ q, handle both cases: rcases h with hp | hq.",
				"ko": "p ∨ q 를 증명하려면 한쪽을 고릅니다: left 또는 right. h : p ∨ q 를 쓰려면 두 경우를 모두 다룹니다: rcases h with hp | hq.",
			},
			{
				"en": "and_or_distrib: take the ∧ apart first, then split the ∨ inside it; each case proves one side of the result.",
				"ko": "and_or_distrib: 먼저 ∧ 를 풀고, 그 안의 ∨ 를 나눕니다. 각 경우가 결과의 한쪽을 증명합니다.",
			},
		},
		Hint: L{
			"en": "or_swap: intro h, rcases h with hp | hq, then right; exact hp in the first case and left; exact hq in the second. or_elim: the same cases, with hpr and hqr. and_or_distrib: intro ⟨hp, hqr⟩, rcases hqr with hq | hr, then Or.inl ⟨hp, hq⟩ or Or.inr ⟨hp, hr⟩.",
			"ko": "or_swap: intro h, rcases h with hp | hq 다음, 첫 경우는 right; exact hp, 둘째는 left; exact hq. or_elim: 같은 경우 나누기에 hpr 과 hqr. and_or_distrib: intro ⟨hp, hqr⟩, rcases hqr with hq | hr 다음 Or.inl ⟨hp, hq⟩ 또는 Or.inr ⟨hp, hr⟩.",
		},
	},
	{
		Name:   "041_not",
		Expect: fill().without(logic...),
		Broken: blank("theorem double_neg_intro"),
		Nudges: []L{
			{
				"en": "¬p means p → False: to prove ¬p, intro hp and reach False; to use hnp : ¬p, apply it to a proof of p.",
				"ko": "¬p 는 p → False 입니다. ¬p 를 증명하려면 intro hp 하고 False 에 이르고, hnp : ¬p 를 쓰려면 p 의 증명에 적용합니다.",
			},
			{
				"en": "When the goal is not False but the hypotheses contradict each other, exfalso turns the goal into False, and contradiction finds hp and ¬p among them.",
				"ko": "목표가 False 가 아닌데 가정끼리 모순이면, exfalso 가 목표를 False 로 바꾸고 contradiction 이 가정들 중에서 hp 와 ¬p 를 찾습니다.",
			},
		},
		Hint: L{
			"en": "double_neg_intro: intro hp hnp, exact hnp hp. contrapositive: intro hpq hnq hp, exact hnq (hpq hp). not_and_left: intro hnp ⟨hp, _⟩, exact hnp hp. absurd_example: intro hp hnp, exfalso, exact hnp hp. not_both: intro ⟨hp, hnp⟩, contradiction.",
			"ko": "double_neg_intro: intro hp hnp, exact hnp hp. contrapositive: intro hpq hnq hp, exact hnq (hpq hp). not_and_left: intro hnp ⟨hp, _⟩, exact hnp hp. absurd_example: intro hp hnp, exfalso, exact hnp hp. not_both: intro ⟨hp, hnp⟩, contradiction.",
		},
	},
	{
		Name:   "042_iff",
		Expect: fill().without(logic...),
		Broken: blank("theorem and_comm_iff"),
		Nudges: []L{
			{
				"en": "p ↔ q is two implications: constructor splits it into p → q and q → p. To use h : p ↔ q, h.mp goes left to right and h.mpr right to left.",
				"ko": "p ↔ q 는 함의 두 개입니다. constructor 가 p → q 와 q → p 로 나눕니다. h : p ↔ q 를 쓸 때 h.mp 는 왼쪽에서 오른쪽, h.mpr 는 오른쪽에서 왼쪽입니다.",
			},
			{
				"en": "not_or_iff: from ¬(p ∨ q), get ¬p by showing that p would give p ∨ q. The other direction splits p ∨ q into cases.",
				"ko": "not_or_iff: ¬(p ∨ q) 에서 ¬p 를 얻으려면 p 가 있으면 p ∨ q 가 된다는 것을 보이면 됩니다. 반대 방향은 p ∨ q 로 경우를 나눕니다.",
			},
		},
		Hint: L{
			"en": "constructor, then prove each direction. not_or_iff, left to right: ⟨fun hp => h (Or.inl hp), fun hq => h (Or.inr hq)⟩. Right to left: intro ⟨hnp, hnq⟩ h, then cases on h. iff_use: h.mpr hq.",
			"ko": "constructor 다음 방향마다 증명하세요. not_or_iff 의 왼쪽에서 오른쪽: ⟨fun hp => h (Or.inl hp), fun hq => h (Or.inr hq)⟩. 오른쪽에서 왼쪽: intro ⟨hnp, hnq⟩ h 다음 h 로 경우 나누기. iff_use: h.mpr hq.",
		},
	},
	{
		Name:   "043_forall",
		Expect: fill().without(logic...),
		Broken: blank("theorem all_imp"),
		Nudges: []L{
			{
				"en": "A proof of ∀ x, P x is a function: apply it to a value to get P of that value (h 5). To prove one, intro x.",
				"ko": "∀ x, P x 의 증명은 함수입니다. 값에 적용하면 그 값에 대한 P 를 얻습니다 (h 5). 증명하려면 intro x.",
			},
		},
		Hint: L{
			"en": "all_imp: intro x, exact h1 x (h2 x). two_instances: ⟨h 5, h 7⟩. forall_and_split: intro h, exact ⟨fun x => (h x).1, fun x => (h x).2⟩. even_add_two: h 4 even_four.",
			"ko": "all_imp: intro x, exact h1 x (h2 x). two_instances: ⟨h 5, h 7⟩. forall_and_split: intro h, exact ⟨fun x => (h x).1, fun x => (h x).2⟩. even_add_two: h 4 even_four.",
		},
	},
	{
		Name:   "044_exists",
		Expect: fill().without(logic...),
		Broken: blank("theorem square_49"),
		Nudges: []L{
			{
				"en": "To prove ∃ x, P x, give a witness and a proof: ⟨7, ...⟩. To use h : ∃ x, P x, take it apart: intro ⟨x, hx⟩ or obtain ⟨x, hx⟩ := h.",
				"ko": "∃ x, P x 를 증명하려면 증거와 증명을 줍니다: ⟨7, ...⟩. h : ∃ x, P x 를 쓰려면 풉니다: intro ⟨x, hx⟩ 또는 obtain ⟨x, hx⟩ := h.",
			},
			{
				"en": "not_exists_iff has two directions. From ¬∃, show that each x fails, by building the ∃ it would give. From ∀ ... ¬, take the ∃ apart and apply.",
				"ko": "not_exists_iff 는 두 방향입니다. ¬∃ 에서는 x 가 성립하면 만들어질 ∃ 를 만들어 각 x 가 안 된다는 것을 보입니다. ∀ ... ¬ 에서는 ∃ 를 풀고 적용합니다.",
			},
		},
		Hint: L{
			"en": "square_49: ⟨7, rfl⟩. exists_map: intro ⟨x, hx⟩, exact ⟨x, h x hx⟩. not_exists_iff: constructor; left to right, intro h x hx, exact h ⟨x, hx⟩; right to left, intro h ⟨x, hx⟩, exact h x hx.",
			"ko": "square_49: ⟨7, rfl⟩. exists_map: intro ⟨x, hx⟩, exact ⟨x, h x hx⟩. not_exists_iff: constructor 다음, 왼쪽에서 오른쪽은 intro h x hx, exact h ⟨x, hx⟩, 오른쪽에서 왼쪽은 intro h ⟨x, hx⟩, exact h x hx.",
		},
	},
	{
		Name:   "045_rewrite",
		Expect: fill().without(logic...),
		Broken: blank("theorem eq_chain"),
		Nudges: []L{
			{
				"en": "rw [h] replaces the left side of h with its right side, and rw [← h] goes the other way. Which equations turn the goal into x = x?",
				"ko": "rw [h] 는 h 의 왼쪽을 오른쪽으로 바꾸고, rw [← h] 는 반대로 바꿉니다. 어떤 등식들이 목표를 x = x 로 만드나요?",
			},
			{
				"en": "reverse_sum and undo_succ need the library's theorems listed in the comment. Give Nat.add_comm arguments so that it swaps the sum you want.",
				"ko": "reverse_sum 과 undo_succ 에는 주석에 있는 라이브러리 정리가 필요합니다. 원하는 합을 바꾸도록 Nat.add_comm 에 인자를 주세요.",
			},
		},
		Hint: L{
			"en": "eq_chain: rw [h1, h2]. plus_zero: rw [Nat.add_zero, h]. apply_both: rw [h]. reverse_sum: rw [Nat.add_comm (a + b) c, Nat.add_comm a b, Nat.add_assoc]. undo_succ: rw [← h, Nat.add_sub_cancel].",
			"ko": "eq_chain: rw [h1, h2]. plus_zero: rw [Nat.add_zero, h]. apply_both: rw [h]. reverse_sum: rw [Nat.add_comm (a + b) c, Nat.add_comm a b, Nat.add_assoc]. undo_succ: rw [← h, Nat.add_sub_cancel].",
		},
	},
	{
		Name:   "046_calc",
		Expect: fill().without(logic...),
		Broken: blank("theorem lt_chain"),
		Nudges: []L{
			{
				"en": "Each step of calc relates the previous term, written _, to a new one, with a proof. Chaining =, ≤ and < gives the relation of the whole.",
				"ko": "calc 의 각 단계는 _ 로 쓰는 앞 항과 새 항의 관계를 증명과 함께 적습니다. =, ≤, < 를 이으면 전체의 관계가 나옵니다.",
			},
			{
				"en": "double_double: rewrite a with h first, then turn 2 * b + 2 * b into (2 + 2) * b. The library's distributivity is stated the other way round: use .symm.",
				"ko": "double_double: 먼저 h 로 a 를 바꾸고, 그다음 2 * b + 2 * b 를 (2 + 2) * b 로 바꿉니다. 라이브러리의 분배 법칙은 반대 방향으로 적혀 있으니 .symm 을 쓰세요.",
			},
		},
		Hint: L{
			"en": "lt_chain: calc a = b := h1, then _ ≤ c := h2 and _ < d := h3. double_double: calc a + a = 2 * b + 2 * b := by rw [h], then _ = (2 + 2) * b := (Nat.add_mul 2 2 b).symm, then _ = 4 * b := rfl.",
			"ko": "lt_chain: calc a = b := h1 다음 _ ≤ c := h2, _ < d := h3. double_double: calc a + a = 2 * b + 2 * b := by rw [h] 다음 _ = (2 + 2) * b := (Nat.add_mul 2 2 b).symm, 그다음 _ = 4 * b := rfl.",
		},
	},
	{
		Name:   "047_classical",
		Expect: fill().without(logic...),
		Broken: blank("theorem excluded_middle"),
		Nudges: []L{
			{
				"en": "Classical logic adds the excluded middle: Classical.em p proves p ∨ ¬p, and by_cases hp : p splits a proof into the cases p and ¬p.",
				"ko": "고전 논리는 배중률을 더합니다. Classical.em p 는 p ∨ ¬p 를 증명하고, by_cases hp : p 는 증명을 p 인 경우와 ¬p 인 경우로 나눕니다.",
			},
			{
				"en": "double_neg_elim: by_cases on p; in the case ¬p, the hypothesis ¬¬p contradicts it. The directions toward ∨ go the same way.",
				"ko": "double_neg_elim: p 로 by_cases 하세요. ¬p 인 경우에는 가정 ¬¬p 와 모순입니다. ∨ 쪽으로 가는 방향들도 같은 방법입니다.",
			},
		},
		Hint: L{
			"en": "excluded_middle: Classical.em p. double_neg_elim: intro hnn, by_cases hp : p; the second case is absurd hp hnn. In not_and_iff and imp_iff_or, the direction toward ∨ needs by_cases hp : p.",
			"ko": "excluded_middle: Classical.em p. double_neg_elim: intro hnn, by_cases hp : p. 둘째 경우는 absurd hp hnn. not_and_iff 와 imp_iff_or 에서 ∨ 로 가는 방향에 by_cases hp : p 가 필요합니다.",
		},
	},
	{
		Name:   "048_proof_errors",
		Expect: debug().without(logic...),
		Broken: Broken{Contains: "Application type mismatch", At: "⟨h.1, h.2⟩"},
		Also: []Broken{
			{Contains: "Alternative `inr` has not been provided", At: "cases h with"},
			{Contains: "could not unify the conclusion", At: "apply hpq"},
			{Contains: "unsolved goals", At: "theorem both_parts"},
			{Contains: "Did not find an occurrence of the pattern", At: "rw [h, Nat.add_sub_cancel]"},
		},
		Nudges: []L{
			{
				"en": "Take the proofs one at a time and read each error first: the position says which proof, the message which of the five problems.",
				"ko": "증명을 하나씩 다루고, 먼저 각 에러를 읽으세요. 위치는 어느 증명인지, 메시지는 다섯 문제 중 어느 것인지 말해 줍니다.",
			},
			{
				"en": "and_swap: which component proves q? or_swap: which case is missing? chain: which hypothesis concludes r? both_parts: which goal is left? undo_two: which side of h is in the goal?",
				"ko": "and_swap: 어느 성분이 q 를 증명하나요? or_swap: 어느 경우가 빠졌나요? chain: 결론이 r 인 가정은 무엇인가요? both_parts: 어느 목표가 남았나요? undo_two: h 의 어느 쪽이 목표에 있나요?",
			},
		},
		Hint: L{
			"en": "and_swap: the first component must prove q: ⟨h.2, h.1⟩. or_swap: add the case | inr hq => exact Or.inl hq. chain: r comes from hqr, so apply hqr, then apply hpq, then exact hp. both_parts: the goal q is left; add · exact hq. undo_two: a + 2 is not in the goal, but b is: rw [← h, Nat.add_sub_cancel].",
			"ko": "and_swap: 첫 성분은 q 를 증명해야 합니다: ⟨h.2, h.1⟩. or_swap: | inr hq => exact Or.inl hq 경우를 더하세요. chain: r 은 hqr 에서 나오므로 apply hqr, apply hpq, exact hp. both_parts: 목표 q 가 남았으니 · exact hq 를 더하세요. undo_two: 목표에 a + 2 는 없고 b 는 있습니다: rw [← h, Nat.add_sub_cancel].",
		},
	},
	{
		Name:   "049_quiz4",
		Expect: fill().without(logic...),
		Broken: blank("theorem or_and_distrib"),
		Nudges: []L{
			{
				"en": "Each is a combination of 037–047: see what the goal is made of (∧, ∨, ∀, ∃, ↔) and use the matching way to prove or to use it.",
				"ko": "모두 037–047 의 조합입니다. 목표가 무엇(∧, ∨, ∀, ∃, ↔)으로 되어 있는지 보고, 그에 맞는 증명 방법과 사용 방법을 쓰세요.",
			},
			{
				"en": "or_and_distrib, right to left: you have (p ∨ q) ∧ (p ∨ r). When p holds you are done; otherwise you have q, and still split p ∨ r.",
				"ko": "or_and_distrib 의 오른쪽에서 왼쪽: (p ∨ q) ∧ (p ∨ r) 가 있습니다. p 가 성립하면 끝이고, 아니면 q 가 있으니 p ∨ r 도 나눕니다.",
			},
		},
		Hint: L{
			"en": "or_and_distrib, right to left: rcases on p ∨ q; when q holds, rcases on p ∨ r too. exists_forall_swap: intro ⟨x, hx⟩ y, exact ⟨x, hx y⟩. forall_not_exists: h x hx. iff_trans': a pair of functions built from .mp and .mpr.",
			"ko": "or_and_distrib 의 오른쪽에서 왼쪽: p ∨ q 로 rcases 하고, q 일 때는 p ∨ r 로도 rcases. exists_forall_swap: intro ⟨x, hx⟩ y, exact ⟨x, hx y⟩. forall_not_exists: h x hx. iff_trans': .mp 와 .mpr 로 만든 함수 한 쌍.",
		},
	},

	// Part 5: induction. Proofs about recursive functions defined in the exercise, so that the
	// library's theorems about List and Nat do not apply. 050-054 by hand (logic), and 054 finds
	// the library's theorems about its own functions; from 055 on, simp and omega are accepted (search).
	{
		Name:   "050_induction",
		Expect: fill().without(logic...),
		Broken: blank("theorem zero_add'"),
		Nudges: []L{
			{
				"en": "Induction on n: prove it for zero, then for n + 1, using ih, the statement for n. In the succ case, rewrite with add_succ' until ih fits.",
				"ko": "n 에 대한 귀납법: zero 에 대해 증명하고, 그다음 n 에 대한 명제인 ih 를 써서 n + 1 에 대해 증명합니다. succ 경우에서는 ih 가 맞을 때까지 add_succ' 로 다시 쓰세요.",
			},
			{
				"en": "add_comm' needs both theorems proved before it: in each case, rewrite until the two sides match.",
				"ko": "add_comm' 에는 앞에서 증명한 두 정리가 필요합니다. 각 경우에서 양변이 같아질 때까지 다시 쓰세요.",
			},
		},
		Hint: L{
			"en": "zero_add': induction n with | zero => rfl | succ n ih => rw [add_succ', ih]. succ_add' is the same, with rw [add_succ', add_succ', ih]. add_comm': induction n; zero: rw [add_zero', zero_add']; succ: rw [add_succ', succ_add', ih].",
			"ko": "zero_add': induction n with | zero => rfl | succ n ih => rw [add_succ', ih]. succ_add' 도 같고, rw [add_succ', add_succ', ih]. add_comm': induction n 다음 zero 는 rw [add_zero', zero_add'], succ 는 rw [add_succ', succ_add', ih].",
		},
	},
	{
		Name:   "051_lists",
		Expect: fill().without(logic...),
		Broken: blank("theorem append_nil"),
		Nudges: []L{
			{
				"en": "Induction on xs: nil, and cons x xs ih. In the cons case, rw [append] unfolds one step of append, and then ih fits.",
				"ko": "xs 에 대한 귀납법: nil, 그리고 cons x xs ih. cons 경우에서 rw [append] 가 append 를 한 단계 펼치면 ih 가 맞습니다.",
			},
			{
				"en": "len_append: after unfolding, the cons case is a rearrangement of a sum; the library has a theorem that swaps the last two of three summands.",
				"ko": "len_append: 펼치고 나면 cons 경우는 합의 순서를 바꾸는 문제입니다. 라이브러리에 세 항 중 뒤의 두 항을 바꾸는 정리가 있습니다.",
			},
		},
		Hint: L{
			"en": "append_nil: induction xs with | nil => rfl | cons x xs ih => rw [append, ih]. append_assoc: rw [append, append, append, ih] in the cons case. len_append: nil, rw [append, len, Nat.zero_add]; cons, rw [append, len, len, ih, Nat.add_right_comm].",
			"ko": "append_nil: induction xs with | nil => rfl | cons x xs ih => rw [append, ih]. append_assoc: cons 경우에 rw [append, append, append, ih]. len_append: nil 은 rw [append, len, Nat.zero_add], cons 는 rw [append, len, len, ih, Nat.add_right_comm].",
		},
	},
	{
		Name:   "052_map",
		Expect: fill().without(logic...),
		Broken: blank("theorem map_id'"),
		Nudges: []L{
			{
				"en": "The same pattern as 051: induction on xs, nil by rfl, and in the cons case unfold map (and append) with rw until ih applies.",
				"ko": "051 과 같은 틀입니다. xs 에 대한 귀납법, nil 은 rfl, cons 경우는 ih 를 쓸 수 있을 때까지 rw 로 map (과 append) 을 펼치세요.",
			},
		},
		Hint: L{
			"en": "Induction on xs, nil by rfl. cons: map_id', rw [map, ih]; map_map, rw [map, map, map, ih]; map_append, rw [append, map, map, append, ih].",
			"ko": "xs 에 대한 귀납, nil 은 rfl. cons: map_id' 는 rw [map, ih], map_map 은 rw [map, map, map, ih], map_append 는 rw [append, map, map, append, ih].",
		},
	},
	{
		Name:   "053_lemmas",
		Expect: fill().without(logic...),
		Broken: blank("theorem reverse_append"),
		Nudges: []L{
			{
				"en": "reverse_reverse does not go through directly. Prove reverse_append first: how reverse treats an append.",
				"ko": "reverse_reverse 는 바로 되지 않습니다. 먼저 reverse_append, 곧 reverse 가 append 를 어떻게 다루는지 증명하세요.",
			},
			{
				"en": "reverse_append, cons case: unfold append and reverse, use ih, then the given append_assoc.",
				"ko": "reverse_append 의 cons 경우: append 와 reverse 를 펼치고, ih 를 쓴 다음, 주어진 append_assoc 를 쓰세요.",
			},
		},
		Hint: L{
			"en": "reverse_append: induction xs; nil, rw [append, reverse, append_nil]; cons, rw [append, reverse, reverse, ih, append_assoc]. reverse_reverse: cons, rw [reverse, reverse_append, ih], then rfl.",
			"ko": "reverse_append: xs 에 대한 귀납. nil 은 rw [append, reverse, append_nil], cons 는 rw [append, reverse, reverse, ih, append_assoc]. reverse_reverse: cons 는 rw [reverse, reverse_append, ih] 다음 rfl.",
		},
	},
	{
		Name:   "054_finding_lemmas",
		Expect: fill().without(logic...),
		Broken: blank("theorem len_append"),
		Nudges: []L{
			{
				"en": "Write exact? as each proof and run speclings lean: the suggestions (Try this: ...) come in the order of the proofs.",
				"ko": "각 증명에 exact? 를 쓰고 speclings lean 을 실행하세요. 제안(Try this: ...)이 증명 순서대로 나옵니다.",
			},
			{
				"en": "len_rev_append takes several steps: rw? suggests a first rewrite; after it, try rw? or exact? again on what is left.",
				"ko": "len_rev_append 는 여러 단계입니다. rw? 가 첫 다시 쓰기를 제안합니다. 그다음 남은 것에 다시 rw? 나 exact? 를 써 보세요.",
			},
		},
		Hint: L{
			"en": "Write exact? as each proof, run speclings lean, and use what follows Try this. For len_rev_append exact? finds nothing: rw? suggests List.length_reverse, then List.length_append, and exact? then finds Nat.add_comm. In all: List.length_append, List.reverse_reverse xs, List.length_map f, Nat.le_of_lt h, Nat.sub_add_cancel h, and rw [List.length_reverse, List.length_append, Nat.add_comm].",
			"ko": "각 증명에 exact? 를 쓰고 speclings lean 을 실행한 다음, Try this 뒤에 나온 것을 쓰세요. len_rev_append 는 exact? 가 못 찾습니다. rw? 가 List.length_reverse, 그다음 List.length_append 를 제안하고, 그러면 exact? 가 Nat.add_comm 을 찾습니다. 모두: List.length_append, List.reverse_reverse xs, List.length_map f, Nat.le_of_lt h, Nat.sub_add_cancel h, 그리고 rw [List.length_reverse, List.length_append, Nat.add_comm].",
		},
	},
	{
		Name:   "055_simp_omega",
		Expect: fill().without(search...),
		Broken: blank("theorem shuffle"),
		Nudges: []L{
			{
				"en": "omega alone proves the arithmetic ones. For the lists: induction, then simp with the definitions (and ih), and omega for any arithmetic left.",
				"ko": "산술 문제는 omega 혼자 증명합니다. 리스트 문제는 귀납법, 그다음 정의 (와 ih) 를 준 simp, 남은 산술은 omega 입니다.",
			},
		},
		Hint: L{
			"en": "shuffle and reverse_sum: omega. len_append: induction xs; nil, simp [append, len]; cons, simp [append, len, ih]; omega. append_nil: induction xs <;> simp [append, *]. len_append_nil: simp.",
			"ko": "shuffle 과 reverse_sum: omega. len_append: xs 에 대한 귀납. nil 은 simp [append, len], cons 는 simp [append, len, ih]; omega. append_nil: induction xs <;> simp [append, *]. len_append_nil: simp.",
		},
	},
	{
		Name:   "056_generalizing",
		Expect: fill().without(search...),
		Broken: blank("theorem sumAcc_eq"),
		Nudges: []L{
			{
				"en": "Try induction xs as usual and read what omega reports: the ih is about acc, but the goal about acc + x.",
				"ko": "평소처럼 induction xs 를 해 보고 omega 가 보고하는 것을 읽으세요. ih 는 acc 에 관한 것인데 목표는 acc + x 에 관한 것입니다.",
			},
			{
				"en": "induction xs generalizing acc makes the ih hold for every acc. sumTR_eq then follows from sumAcc_eq by simp.",
				"ko": "induction xs generalizing acc 로 ih 가 모든 acc 에 대해 성립하게 합니다. 그러면 sumTR_eq 는 simp 와 sumAcc_eq 로 나옵니다.",
			},
		},
		Hint: L{
			"en": "sumAcc_eq: induction xs generalizing acc; nil, simp [sumAcc, sum]; cons, simp [sumAcc, sum, ih]; omega. sumTR_eq: simp [sumTR, sumAcc_eq]. revAcc_eq: induction xs generalizing acc, then simp [revAcc, ih] in the cons case.",
			"ko": "sumAcc_eq: induction xs generalizing acc. nil 은 simp [sumAcc, sum], cons 는 simp [sumAcc, sum, ih]; omega. sumTR_eq: simp [sumTR, sumAcc_eq]. revAcc_eq: induction xs generalizing acc 다음 cons 경우에 simp [revAcc, ih].",
		},
	},
	{
		Name:   "057_trees",
		Expect: fill().without(search...),
		Broken: blank("theorem mirror_mirror"),
		Nudges: []L{
			{
				"en": "Induction on a tree gives two induction hypotheses in the node case, one per subtree. Give simp the definition and both of them.",
				"ko": "트리에 대한 귀납법은 node 경우에 서브트리마다 하나씩 귀납 가정 두 개를 줍니다. simp 에 정의와 둘 다를 주세요.",
			},
		},
		Hint: L{
			"en": "induction t with | leaf => rfl | node l v r ihl ihr => simp [mirror, ihl, ihr]. Add size or toList to the simp list for the other two, and omega after it for size_mirror.",
			"ko": "induction t with | leaf => rfl | node l v r ihl ihr => simp [mirror, ihl, ihr]. 나머지 둘은 simp 목록에 size 나 toList 를 더하고, size_mirror 는 그 뒤에 omega.",
		},
	},
	{
		Name:   "058_fun_induction",
		Expect: fill().without(search...),
		Broken: blank("theorem evens_le"),
		Nudges: []L{
			{
				"en": "fun_induction evens xs gives one case per case of evens, with an ih where it calls itself. In each case: simp, then omega for what is left.",
				"ko": "fun_induction evens xs 는 evens 의 경우마다 한 경우를 주고, 자기 자신을 부르는 곳에 ih 를 줍니다. 각 경우: simp, 남은 것은 omega.",
			},
		},
		Hint: L{
			"en": "fun_induction evens xs with | case1 => simp | case2 x => simp | case3 x y xs ih => simp; omega. The same works for evens_half.",
			"ko": "fun_induction evens xs with | case1 => simp | case2 x => simp | case3 x y xs ih => simp; omega. evens_half 도 같은 방법으로 됩니다.",
		},
	},
	{
		Name:   "059_induction_errors",
		Expect: debug().without(search...),
		Broken: Broken{Contains: "omega could not prove the goal", At: "| cons x xs ih => simp [lenAcc, ih]; omega"},
		Also: []Broken{
			{Severity: sevWarning, Contains: "This simp argument is unused", At: "| cons x xs ih => simp [lenAcc, ih]; omega"},
			{Contains: "made no progress", At: "theorem lenAcc_zero"},
			{Contains: "Failed to rewrite using equation theorems for `double`", At: "rw [double]"},
			{Contains: "No usable constraints found", At: "theorem even_add_two"},
		},
		Nudges: []L{
			{
				"en": "Read each message before changing anything; the comment says what each means.",
				"ko": "무엇이든 바꾸기 전에 각 메시지를 읽으세요. 주석에 각각이 무슨 뜻인지 있습니다.",
			},
			{
				"en": "lenAcc_eq: which argument changes in the recursive call? lenAcc_zero: simp needs a theorem you proved. double_pos: what shape must n have for rw [double]? even_add_two: what does omega not see?",
				"ko": "lenAcc_eq: 재귀 호출에서 어느 인자가 바뀌나요? lenAcc_zero: simp 에 여러분이 증명한 정리가 필요합니다. double_pos: rw [double] 을 하려면 n 이 어떤 모양이어야 하나요? even_add_two: omega 가 보지 못하는 것은 무엇인가요?",
			},
		},
		Hint: L{
			"en": "lenAcc_eq: induction xs generalizing acc. lenAcc_zero: simp [lenAcc_eq]. double_pos: cases n with | zero => omega | succ k => rw [double]; omega. even_add_two: unfold IsEven at *, then omega.",
			"ko": "lenAcc_eq: induction xs generalizing acc. lenAcc_zero: simp [lenAcc_eq]. double_pos: cases n with | zero => omega | succ k => rw [double]; omega. even_add_two: unfold IsEven at * 다음 omega.",
		},
	},
	{
		Name:   "060_quiz5",
		Expect: fill().without(search...),
		Broken: blank("theorem eval_addS"),
		Nudges: []L{
			{
				"en": "Prove the lemmas about addS and mulS first: unfold them and split on their cases. simplify_correct then goes by induction on e, using them.",
				"ko": "먼저 addS 와 mulS 에 관한 보조 정리를 증명하세요. 펼친 다음 경우를 나눕니다. 그러면 simplify_correct 는 그것들을 써서 e 에 대한 귀납법으로 됩니다.",
			},
		},
		Hint: L{
			"en": "eval_addS: unfold addS, then split <;> simp [eval]; the same for eval_mulS. simplify_correct: induction e; num, rfl; add, rw [simplify, eval_addS, iha, ihb, eval]; mul, the same with eval_mulS.",
			"ko": "eval_addS: unfold addS 다음 split <;> simp [eval]. eval_mulS 도 같습니다. simplify_correct: e 에 대한 귀납. num 은 rfl, add 는 rw [simplify, eval_addS, iha, ihb, eval], mul 은 eval_mulS 로 같게.",
		},
	},

	// Part 6: dependent types. Proofs inside programs: index proofs, Fin, length-indexed vectors,
	// subtypes, termination proofs, invariants and Decidable instances.
	{
		Name:   "061_indices",
		Expect: fix().without(search...),
		Broken: Broken{Contains: "failed to prove index is valid", At: "def third"},
		Nudges: []L{
			{
				"en": "Lean needs a proof that the index is in range: give third one as a hypothesis. For the Fin values, Fin n counts modulo n.",
				"ko": "Lean 은 인덱스가 범위 안이라는 증명이 필요합니다. third 에 가정으로 주세요. Fin 값들은, Fin n 이 n 을 법으로 센다는 것을 떠올리세요.",
			},
		},
		Hint: L{
			"en": "Give third a hypothesis: def third (xs : Array Nat) (h : 2 < xs.size) : Nat := xs[2]. Fin 5 counts modulo 5: 3 + 4 is 7, which is 2. Fin.last 4 is the largest Fin 5, 4.",
			"ko": "third 에 가정을 주세요: def third (xs : Array Nat) (h : 2 < xs.size) : Nat := xs[2]. Fin 5 는 5 로 나눈 나머지로 셉니다. 3 + 4 는 7 이고, 이는 2 입니다. Fin.last 4 는 가장 큰 Fin 5 인 4 입니다.",
		},
	},
	{
		Name:   "062_vectors",
		Expect: fix().without(search...),
		Broken: Broken{Contains: "Type mismatch", At: "| nil, ys => ys"},
		Nudges: []L{
			{
				"en": "Read the type mismatch: the lengths in the types must compute to the same Nat. Which argument of + does Nat's addition compute on?",
				"ko": "타입 불일치를 읽으세요. 타입의 길이가 같은 Nat 으로 계산되어야 합니다. Nat 의 덧셈은 + 의 어느 인자로 계산하나요?",
			},
			{
				"en": "Write append's length so that each case computes like the types of nil and cons. map and zip keep the length.",
				"ko": "append 의 길이를 각 경우가 nil 과 cons 의 타입처럼 계산되도록 쓰세요. map 과 zip 은 길이를 유지합니다.",
			},
		},
		Hint: L{
			"en": "append returns Vec α (n + m): then nil gives n + 0, which computes to n, and cons gives n + (m' + 1), which computes to (n + m') + 1. map: | nil => nil | cons x xs => cons (f x) (xs.map f). zip: | nil, nil => nil | cons x xs, cons y ys => cons (x, y) (zip xs ys).",
			"ko": "append 가 Vec α (n + m) 을 돌려주게 하세요. 그러면 nil 은 n + 0 이 되어 n 으로 계산되고, cons 는 n + (m' + 1) 이 되어 (n + m') + 1 로 계산됩니다. map: | nil => nil | cons x xs => cons (f x) (xs.map f). zip: | nil, nil => nil | cons x xs, cons y ys => cons (x, y) (zip xs ys).",
		},
	},
	{
		Name:   "063_subtypes",
		Expect: fill().without(search...),
		Broken: blank("def ten"),
		Nudges: []L{
			{
				"en": "A value of { n : Nat // P n } is a pair ⟨n, a proof of P n⟩. Prove P n by rfl, decide or omega; have := a.property brings what a already guarantees.",
				"ko": "{ n : Nat // P n } 의 값은 쌍 ⟨n, P n 의 증명⟩ 입니다. P n 은 rfl, decide, omega 로 증명하고, have := a.property 가 a 가 이미 보장하는 것을 가져옵니다.",
			},
		},
		Hint: L{
			"en": "ten: ⟨10, rfl⟩. addEven: ⟨a.val + b.val, by have := a.property; have := b.property; omega⟩. double: ⟨2 * n, by omega⟩. three: ⟨3, by decide⟩.",
			"ko": "ten: ⟨10, rfl⟩. addEven: ⟨a.val + b.val, by have := a.property; have := b.property; omega⟩. double: ⟨2 * n, by omega⟩. three: ⟨3, by decide⟩.",
		},
	},
	{
		Name:   "064_proof_args",
		Expect: fill().without(search...),
		Broken: blank("def firstAndLast"),
		Nudges: []L{
			{
				"en": "With h : xs ≠ [] or h : xs.length ≥ 2 in scope, the functions that need a proof find it: xs.head h, xs[1]. For secondOfLong, prove the precondition from the one you have.",
				"ko": "h : xs ≠ [] 나 h : xs.length ≥ 2 가 있으면, 증명이 필요한 함수가 그것을 찾습니다: xs.head h, xs[1]. secondOfLong 은 가진 전제로 필요한 전제를 증명하세요.",
			},
		},
		Hint: L{
			"en": "firstAndLast: (xs.head h, xs.getLast h). second: xs[1]. middle: xs[xs.length / 2]. Lean finds the index proofs from h. secondOfLong: second xs (by omega).",
			"ko": "firstAndLast: (xs.head h, xs.getLast h). second: xs[1]. middle: xs[xs.length / 2]. Lean 이 h 로부터 인덱스 증명을 찾습니다. secondOfLong: second xs (by omega).",
		},
	},
	{
		Name:   "065_termination",
		Expect: fix().without(search...),
		Broken: Broken{Contains: "fail to show termination", At: "def euclid"},
		Nudges: []L{
			{
				"en": "Lean cannot see that the argument gets smaller. Use the dependent if, if h : b = 0, so that the else branch knows b ≠ 0.",
				"ko": "Lean 은 인자가 작아진다는 것을 알지 못합니다. 의존 if, 곧 if h : b = 0 을 쓰면 else 갈래가 b ≠ 0 을 압니다.",
			},
			{
				"en": "Then say what decreases (termination_by b) and prove it (decreasing_by): a % b < b when b > 0. exact? finds the library's theorems for both steps.",
				"ko": "그다음 무엇이 줄어드는지 말하고 (termination_by b) 증명하세요 (decreasing_by). b > 0 이면 a % b < b 입니다. 두 단계에 필요한 라이브러리 정리는 exact? 가 찾습니다.",
			},
		},
		Hint: L{
			"en": "Write if h : b = 0 then a else euclid b (a % b), and after the definition: termination_by b, then decreasing_by exact Nat.mod_lt a (Nat.pos_of_ne_zero h).",
			"ko": "if h : b = 0 then a else euclid b (a % b) 로 쓰고, 정의 뒤에 termination_by b, 그다음 decreasing_by exact Nat.mod_lt a (Nat.pos_of_ne_zero h) 를 더하세요.",
		},
	},
	{
		Name:   "066_invariants",
		Expect: fill().without(search...),
		Broken: blank("def make"),
		Nudges: []L{
			{
				"en": "make must prove lo ≤ hi: a dependent if tells which of a and b is smaller. For widen and shift, have := r.ok brings the old invariant, and omega derives the new one.",
				"ko": "make 는 lo ≤ hi 를 증명해야 합니다. 의존 if 로 a 와 b 중 어느 쪽이 작은지 압니다. widen 과 shift 는 have := r.ok 로 옛 불변식을 가져오고, omega 가 새 불변식을 이끌어 냅니다.",
			},
		},
		Hint: L{
			"en": "make: if h : a ≤ b then ⟨a, b, h⟩ else ⟨b, a, by omega⟩. widen: ⟨r.lo, r.hi + k, by have := r.ok; omega⟩, and shift adds k to both. Theorems: have := r.ok, simp only [widen, length], omega.",
			"ko": "make: if h : a ≤ b then ⟨a, b, h⟩ else ⟨b, a, by omega⟩. widen: ⟨r.lo, r.hi + k, by have := r.ok; omega⟩, shift 는 둘 다에 k 를 더합니다. 정리: have := r.ok, simp only [widen, length], omega.",
		},
	},
	{
		Name:   "067_decidable",
		Expect: fill().without(search...),
		Broken: blank("instance (n : Nat) : Decidable (Even n)"),
		Nudges: []L{
			{
				"en": "Even unfolds to n % 2 = 0, which is decidable: tell Lean to use that instance. For Sorted, write a Bool function that follows its cases.",
				"ko": "Even 은 펼치면 n % 2 = 0 이고, 이것은 판정 가능합니다. Lean 에게 그 인스턴스를 쓰라고 하세요. Sorted 는 그 경우들을 따르는 Bool 함수를 쓰세요.",
			},
			{
				"en": "Prove that isSorted agrees with Sorted by fun_induction on isSorted; decidable_of_iff then turns that into the instance.",
				"ko": "isSorted 에 대한 fun_induction 으로 isSorted 가 Sorted 와 일치한다는 것을 증명하세요. 그러면 decidable_of_iff 가 그것을 인스턴스로 바꿉니다.",
			},
		},
		Hint: L{
			"en": "Even: inferInstanceAs (Decidable (n % 2 = 0)). isSorted follows the three cases of Sorted, with a ≤ b && isSorted (b :: rest). isSorted_iff: fun_induction isSorted xs <;> simp_all [Sorted]. The instance: fun xs => decidable_of_iff _ (isSorted_iff xs).",
			"ko": "Even: inferInstanceAs (Decidable (n % 2 = 0)). isSorted 는 Sorted 의 세 경우를 따르고 a ≤ b && isSorted (b :: rest) 를 씁니다. isSorted_iff: fun_induction isSorted xs <;> simp_all [Sorted]. instance: fun xs => decidable_of_iff _ (isSorted_iff xs).",
		},
	},
	{
		Name:   "068_quiz6",
		Expect: fill().without(search...),
		Broken: blank("def bsearch"),
		Nudges: []L{
			{
				"en": "Search between lo and hi: while lo < hi, look at the middle and recurse on the half that may hold x. Use dependent ifs, so that the proofs of the bounds have what they need.",
				"ko": "lo 와 hi 사이를 찾습니다. lo < hi 인 동안 가운데를 보고, x 가 있을 수 있는 절반에서 재귀합니다. 경계 증명에 필요한 것이 있도록 의존 if 를 쓰세요.",
			},
			{
				"en": "Termination: each recursive call narrows the range, so hi - lo decreases.",
				"ko": "종료: 재귀 호출마다 범위가 좁아지므로 hi - lo 가 줄어듭니다.",
			},
		},
		Hint: L{
			"en": "if hlt : lo < hi then (let mid := (lo + hi) / 2; if a[mid] = x then some ⟨mid, by omega⟩ else if a[mid] < x then bsearch a x (mid + 1) hi h else bsearch a x lo mid (by omega)) else none, and termination_by hi - lo after the definition.",
			"ko": "if hlt : lo < hi then (let mid := (lo + hi) / 2; if a[mid] = x then some ⟨mid, by omega⟩ else if a[mid] < x then bsearch a x (mid + 1) hi h else bsearch a x lo mid (by omega)) else none, 그리고 정의 뒤에 termination_by hi - lo.",
		},
	},

	// Part 7: verified programs. Specifications and proofs of sorting, binary search, a compiler
	// and state machines, with grind. Only the search tactics stay forbidden (suggest).
	{
		Name:   "069_grind",
		Expect: fill().without(suggest...),
		Broken: blank("theorem gauss"),
		Nudges: []L{
			{
				"en": "grind does not do induction: choose it yourself, then let grind finish each case. Give grind the definitions it should unfold.",
				"ko": "grind 는 귀납법을 하지 않습니다. 귀납법은 직접 고르고, 각 경우를 grind 가 마무리하게 하세요. grind 에 펼칠 정의를 주세요.",
			},
		},
		Hint: L{
			"en": "gauss: induction n with | zero => rfl | succ n ih => grind [sumTo]. square_sum and odd_succ: grind. len_append: induction xs <;> grind [append, len].",
			"ko": "gauss: induction n with | zero => rfl | succ n ih => grind [sumTo]. square_sum 과 odd_succ: grind. len_append: induction xs <;> grind [append, len].",
		},
	},
	{
		Name:   "070_sorted",
		Expect: fill().without(suggest...),
		Broken: blank("theorem sorted_123"),
		Nudges: []L{
			{
				"en": "A proof of Sorted [1, 2, 3] is built from the constructors, like a value; the premises x ≤ y are by decide. To show that a list is not sorted, take a proof apart with cases.",
				"ko": "Sorted [1, 2, 3] 의 증명은 값처럼 생성자들로 만듭니다. 전제 x ≤ y 는 decide 로 증명합니다. 리스트가 정렬되지 않았다는 것은 증명을 cases 로 풀어서 보이세요.",
			},
			{
				"en": "ins_sorted: induction on the proof of Sorted (induction h), then grind with ins and the three constructors.",
				"ko": "ins_sorted: Sorted 의 증명에 대한 귀납법 (induction h), 그다음 ins 와 세 생성자를 준 grind.",
			},
		},
		Hint: L{
			"en": "sorted_123: .cons (by decide) (.cons (by decide) (.single 3)). not_sorted_21: intro h, then cases h with | cons h12 _ => omega. ins_sorted: induction h <;> grind [ins, Sorted.nil, Sorted.single, Sorted.cons].",
			"ko": "sorted_123: .cons (by decide) (.cons (by decide) (.single 3)). not_sorted_21: intro h 다음 cases h with | cons h12 _ => omega. ins_sorted: induction h <;> grind [ins, Sorted.nil, Sorted.single, Sorted.cons].",
		},
	},
	{
		Name:   "071_isort",
		Expect: fill().without(suggest...),
		Broken: blank("theorem isort_sorted"),
		Nudges: []L{
			{
				"en": "isort_sorted follows from ins_sorted by induction on xs. Build the permutations from the rules in the comment: refl, cons, swap and trans.",
				"ko": "isort_sorted 는 xs 에 대한 귀납법과 ins_sorted 로 나옵니다. 순열은 주석의 규칙 refl, cons, swap, trans 로 만드세요.",
			},
			{
				"en": "ins_perm: unfold ins and split on its if; when x goes after y, combine ih.cons with a swap. badSort_not_perm: a permutation keeps the length.",
				"ko": "ins_perm: ins 를 펼치고 그 if 로 나눕니다. x 가 y 뒤로 갈 때는 ih.cons 와 swap 을 이으세요. badSort_not_perm: 순열은 길이를 유지합니다.",
			},
		},
		Hint: L{
			"en": "isort_sorted: induction xs; cons, exact ins_sorted x _ ih. ins_perm: induction xs; cons, unfold ins, split, then .refl _ or (ih.cons y).trans (.swap x y ys). isort_perm: (ins_perm x _).trans (ih.cons x). badSort_not_perm: intro h, have := h.length_eq, simp [badSort] at this.",
			"ko": "isort_sorted: xs 에 대한 귀납. cons 는 exact ins_sorted x _ ih. ins_perm: xs 에 대한 귀납. cons 는 unfold ins, split 다음 .refl _ 또는 (ih.cons y).trans (.swap x y ys). isort_perm: (ins_perm x _).trans (ih.cons x). badSort_not_perm: intro h, have := h.length_eq, simp [badSort] at this.",
		},
	},
	{
		Name:   "072_specifications",
		Expect: fill().without(suggest...),
		Broken: blank("def IsMax"),
		Nudges: []L{
			{
				"en": "Write each specification as the conjunction of the properties the tests ask for, with ∈, ≤ and only ∀ x ∈ xs or ∃ x ∈ xs. Then unfold it and decide the tests.",
				"ko": "각 사양을 시험이 요구하는 성질들의 연언으로 쓰세요. ∈, ≤ 와 ∀ x ∈ xs, ∃ x ∈ xs 만 씁니다. 그다음 펼치고 decide 로 시험을 증명하세요.",
			},
			{
				"en": "maxOf_isMax: prove separately that the result is in the list and that it is at least every element, each by induction xs generalizing x and grind.",
				"ko": "maxOf_isMax: 결과가 리스트에 있다는 것과 모든 원소 이상이라는 것을 따로 증명하세요. 각각 induction xs generalizing x 와 grind 로 됩니다.",
			},
		},
		Hint: L{
			"en": "IsMax xs m := m ∈ xs ∧ ∀ x ∈ xs, x ≤ m. Tests: unfold IsMax; decide, and max_nil: simp [IsMax]. maxOf_isMax: prove x ≤ maxOf x xs, maxOf x xs ∈ x :: xs and ∀ y ∈ x :: xs, y ≤ maxOf x xs, each by induction xs generalizing x <;> grind [maxOf] (the last also with the first), then pair the last two. IsDedup xs ys := ys.Nodup ∧ (∀ y ∈ ys, y ∈ xs) ∧ (∀ x ∈ xs, x ∈ ys). Tests: unfold IsDedup; decide.",
			"ko": "IsMax xs m := m ∈ xs ∧ ∀ x ∈ xs, x ≤ m. 시험: unfold IsMax; decide, 그리고 max_nil: simp [IsMax]. maxOf_isMax: x ≤ maxOf x xs, maxOf x xs ∈ x :: xs, ∀ y ∈ x :: xs, y ≤ maxOf x xs 를 각각 induction xs generalizing x <;> grind [maxOf] 로 증명하고 (마지막 것은 첫 것도 함께), 뒤의 둘을 짝지으세요. IsDedup xs ys := ys.Nodup ∧ (∀ y ∈ ys, y ∈ xs) ∧ (∀ x ∈ xs, x ∈ ys). 시험: unfold IsDedup; decide.",
		},
	},
	{
		Name:   "073_bsearch",
		Expect: fill().without(suggest...),
		Broken: blank("theorem bsearch_sound"),
		Nudges: []L{
			{
				"en": "bsearch is not structurally recursive, so fun_induction follows its cases; in each, simp_all uses what the case knows.",
				"ko": "bsearch 는 구조적 재귀가 아니므로 fun_induction 이 그 경우들을 따라갑니다. 각 경우에서 simp_all 이 그 경우가 아는 것을 씁니다.",
			},
			{
				"en": "find_sound: unfold find, split on what bsearch returns (cases hb : ...), and use bsearch_sound when it returns some j.",
				"ko": "find_sound: find 를 펼치고, bsearch 가 돌려준 것으로 나누고 (cases hb : ...), some j 를 돌려줄 때 bsearch_sound 를 쓰세요.",
			},
		},
		Hint: L{
			"en": "bsearch_sound: fun_induction bsearch a x lo hi h with | case1 => cases hs; simp_all | case2 => simp_all | case3 => simp_all | case4 => simp at hs. find_sound: unfold find at h, cases hb : bsearch a x 0 a.size (Nat.le_refl _); none, simp [hb] at h; some j, simp [hb] at h, have := bsearch_sound a x 0 a.size (Nat.le_refl _) j hb, grind.",
			"ko": "bsearch_sound: fun_induction bsearch a x lo hi h with | case1 => cases hs; simp_all | case2 => simp_all | case3 => simp_all | case4 => simp at hs. find_sound: unfold find at h, cases hb : bsearch a x 0 a.size (Nat.le_refl _). none 은 simp [hb] at h, some j 는 simp [hb] at h, have := bsearch_sound a x 0 a.size (Nat.le_refl _) j hb, grind.",
		},
	},
	{
		Name:   "074_compiler",
		Expect: fill().without(suggest...),
		Broken: blank("theorem exec_compile"),
		Nudges: []L{
			{
				"en": "Prove a stronger statement first: running the code of e on any stack, before any rest of the program, pushes eval e. Induction on e, generalizing what changes.",
				"ko": "먼저 더 강한 명제를 증명하세요. 어떤 스택에서든, 뒤에 어떤 프로그램이 오든, e 의 코드를 실행하면 eval e 를 쌓습니다. e 에 대한 귀납법, 바뀌는 것은 일반화하세요.",
			},
			{
				"en": "compile_correct is then the case of an empty rest and an empty stack.",
				"ko": "그러면 compile_correct 는 뒤의 프로그램과 스택이 비어 있는 경우입니다.",
			},
		},
		Hint: L{
			"en": "exec_compile: induction e generalizing is s, then simp [compile, exec, eval] for num and simp [compile, eval, iha, ihb, exec] for add and mul. compile_correct: simpa [exec] using exec_compile e [] [].",
			"ko": "exec_compile: induction e generalizing is s 다음, num 은 simp [compile, exec, eval], add 와 mul 은 simp [compile, eval, iha, ihb, exec]. compile_correct: simpa [exec] using exec_compile e [] [].",
		},
	},
	{
		Name:   "075_invariants",
		Expect: fill().without(suggest...),
		Broken: blank("theorem bounded"),
		Nudges: []L{
			{
				"en": "Induction on Reachable: the initial state, and a step from a state where the invariant holds. In the step case, cases on the step gives produce and consume.",
				"ko": "Reachable 에 대한 귀납법: 초기 상태, 그리고 불변식이 성립하는 상태에서의 한 단계. 단계 경우에서 그 단계로 cases 하면 produce 와 consume 이 나옵니다.",
			},
			{
				"en": "consumed_le follows from conserved: the counts are Nats.",
				"ko": "consumed_le 는 conserved 에서 나옵니다. 개수들은 Nat 입니다.",
			},
		},
		Hint: L{
			"en": "bounded and conserved: induction h with | init => ... | step _ hst ih => cases hst <;> simp_all <;> omega. The init case: simp [capacity] for bounded, rfl for conserved. consumed_le: have := conserved s h, then omega.",
			"ko": "bounded 와 conserved: induction h with | init => ... | step _ hst ih => cases hst <;> simp_all <;> omega. init 경우는 bounded 는 simp [capacity], conserved 는 rfl. consumed_le: have := conserved s h 다음 omega.",
		},
	},
	{
		Name:   "076_strengthening",
		Expect: fill().without(suggest...),
		Broken: blank("def LockInv"),
		Nudges: []L{
			{
				"en": "Mutex alone is not inductive: add what makes it so. When a process is in its critical section, what is true of the lock?",
				"ko": "Mutex 만으로는 귀납적이지 않습니다. 귀납적으로 만드는 것을 더하세요. 프로세스가 임계 구역에 있을 때 잠금에 대해 무엇이 참인가요?",
			},
			{
				"en": "Prove LockInv by induction on Reachable, cases on the step, and simp_all with the definitions; mutex is its last part.",
				"ko": "LockInv 는 Reachable 에 대한 귀납법, 단계로 cases, 정의를 준 simp_all 로 증명하세요. mutex 는 그 마지막 부분입니다.",
			},
		},
		Hint: L{
			"en": "LockInv s := (s.p1 = .critical → s.locked = true) ∧ (s.p2 = .critical → s.locked = true) ∧ Mutex s. lockInv_holds: induction h; init, simp [LockInv, Mutex]; step, cases hst <;> simp_all [LockInv, Mutex]. mutex: (lockInv_holds s h).2.2.",
			"ko": "LockInv s := (s.p1 = .critical → s.locked = true) ∧ (s.p2 = .critical → s.locked = true) ∧ Mutex s. lockInv_holds: h 에 대한 귀납. init 은 simp [LockInv, Mutex], step 은 cases hst <;> simp_all [LockInv, Mutex]. mutex: (lockInv_holds s h).2.2.",
		},
	},
	{
		Name:   "077_grind_errors",
		Expect: debug().without(suggest...),
		Broken: Broken{Contains: "`grind` failed", At: "induction xs <;> grind [append]"},
		Also: []Broken{
			{Contains: "`grind` failed", At: "grind [ins]"},
			{Severity: sevWarning, Kind: kindSorry, At: "theorem sum_append"},
			{Contains: "`grind` failed", At: "induction xs <;> grind [sum]"},
		},
		Nudges: []L{
			{
				"en": "Read each failure's diagnostics: a strange value under [cutsat] shows a missing definition, a goal about a list grind knows nothing about needs induction, and a stuck term needs a lemma.",
				"ko": "각 실패의 진단을 읽으세요. [cutsat] 아래의 이상한 값은 빠진 정의를, grind 가 아무것도 모르는 리스트에 관한 목표는 귀납법을, 막힌 항은 보조 정리를 뜻합니다.",
			},
			{
				"en": "sum_reverse gets stuck on the sum of an append: prove sum_append first, by induction, and give it to grind.",
				"ko": "sum_reverse 는 append 의 sum 에서 막힙니다. 먼저 sum_append 를 귀납법으로 증명하고 grind 에 주세요.",
			},
		},
		Hint: L{
			"en": "len_append: grind [append, len]. ins_length: induction xs <;> grind [ins]. sum_append: induction xs <;> grind [sum]. sum_reverse: induction xs <;> grind [sum, sum_append].",
			"ko": "len_append: grind [append, len]. ins_length: induction xs <;> grind [ins]. sum_append: induction xs <;> grind [sum]. sum_reverse: induction xs <;> grind [sum, sum_append].",
		},
	},
	{
		Name:   "078_quiz7",
		Expect: fill().without(suggest...),
		Broken: blank("theorem all_insert"),
		Nudges: []L{
			{
				"en": "Every proof is by induction on the tree, then grind with the right definitions.",
				"ko": "모든 증명은 트리에 대한 귀납법, 그다음 알맞은 정의를 준 grind 입니다.",
			},
			{
				"en": "insert_bst needs to know that inserting keeps All: prove all_insert first, and give it to grind.",
				"ko": "insert_bst 는 삽입해도 All 이 유지된다는 것을 알아야 합니다. 먼저 all_insert 를 증명하고 grind 에 주세요.",
			},
		},
		Hint: L{
			"en": "all_insert: induction t <;> grind [insert, All]. insert_bst: induction t <;> grind [insert, BST, All, all_insert]. contains_insert: induction t <;> grind [insert, contains].",
			"ko": "all_insert: induction t <;> grind [insert, All]. insert_bst: induction t <;> grind [insert, BST, All, all_insert]. contains_insert: induction t <;> grind [insert, contains].",
		},
	},
}

// renamed maps the former names of exercises to their current names: exercises were
// renumbered when 048, 054, 059, 072 and 077 were added. speclings moves learners'
// progress and files in work/lean/ to the current names (lings.Exercise.Was).
var renamed = map[string]string{
	"048_quiz4":         "049_quiz4",
	"049_induction":     "050_induction",
	"050_lists":         "051_lists",
	"051_map":           "052_map",
	"052_lemmas":        "053_lemmas",
	"053_simp_omega":    "055_simp_omega",
	"054_generalizing":  "056_generalizing",
	"055_trees":         "057_trees",
	"056_fun_induction": "058_fun_induction",
	"057_quiz5":         "060_quiz5",
	"058_indices":       "061_indices",
	"059_vectors":       "062_vectors",
	"060_subtypes":      "063_subtypes",
	"061_proof_args":    "064_proof_args",
	"062_termination":   "065_termination",
	"063_invariants":    "066_invariants",
	"064_decidable":     "067_decidable",
	"065_quiz6":         "068_quiz6",
	"066_grind":         "069_grind",
	"067_sorted":        "070_sorted",
	"068_isort":         "071_isort",
	"069_bsearch":       "073_bsearch",
	"070_compiler":      "074_compiler",
	"071_invariants":    "075_invariants",
	"072_strengthening": "076_strengthening",
	"073_quiz7":         "078_quiz7",
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
	Hint   L        // the last and fullest hint
	Nudges []L      // hints before Hint, from the vaguest (lings.Exercise)
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
