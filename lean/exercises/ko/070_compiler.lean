-- leanlings 070: 컴파일러
--
-- 023 의 식을 스택 머신으로 컴파일합니다. 프로그램은 명령의 리스트이고,
-- exec 는 그것을 스택 위에서 실행합니다. 스택은 머리가 맨 위인
-- 리스트입니다:
--
--   push n    n 을 스택에 올림
--   add       맨 위의 수 두 개를 꺼내고 그 합을 올림
--   mul       같은 식으로, 곱을
--
-- compile 은 두 피연산자의 코드를 먼저 두고 그다음 연산을 둡니다. 그래서
-- (2 + 3) * 4 는 push 2, push 3, add, push 4, mul 이 됩니다. 아래 #eval 이
-- 그것을 실행합니다.
--
-- compile_correct 는 e 의 코드를 실행하면 정확히 그 값만 남는다는
-- 것입니다. 이것을 e 에 대한 귀납법으로 증명하면 막힙니다. a + b 의 코드는
-- a 의 코드를 뒤에 다른 코드가 있는 채로, 그리고 비어 있지 않은 스택
-- 위에서 실행하는데, 귀납 가정은 [] 위에서 홀로 실행한 코드만 알기
-- 때문입니다. 그러니 먼저 뒤에 오는 아무 코드, 아무 스택에 대한 일반적인
-- 명제를 증명하세요. exec_compile 을 is 와 s 를 일반화한 e 에 대한
-- 귀납법으로 (054). 정의와 귀납 가정을 받은 simp 가 각 경우를 처리합니다.

inductive Expr where
  | num (n : Nat)
  | add (a b : Expr)
  | mul (a b : Expr)

def eval : Expr → Nat
  | .num n => n
  | .add a b => eval a + eval b
  | .mul a b => eval a * eval b

inductive Instr where
  | push (n : Nat)
  | add
  | mul

def exec : List Instr → List Nat → List Nat
  | [], s => s
  | .push n :: is, s => exec is (n :: s)
  | .add :: is, b :: a :: s => exec is ((a + b) :: s)
  | .mul :: is, b :: a :: s => exec is ((a * b) :: s)
  | _ :: is, s => exec is s

def compile : Expr → List Instr
  | .num n => [.push n]
  | .add a b => compile a ++ compile b ++ [.add]
  | .mul a b => compile a ++ compile b ++ [.mul]

#eval exec (compile (.mul (.add (.num 2) (.num 3)) (.num 4))) []

theorem exec_compile (e : Expr) (is : List Instr) (s : List Nat) :
    exec (compile e ++ is) s = exec is (eval e :: s) := by
  sorry

theorem compile_correct (e : Expr) : exec (compile e) [] = [eval e] := by
  sorry
