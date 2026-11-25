-- speclings lean 060: 퀴즈 5
--
-- 023 에서 식에서 0 을 더하는 것과 1 을 곱하는 것을 없애는 simplify 를
-- 썼습니다. 여기 같은 일을 보조 함수 둘로 하는 버전이 있습니다. addS a b
-- 는 a + b 를 만들되 0 은 빼고, mulS a b 는 a * b 를 만들되 1 은 뺍니다.
-- simplify 가 식의 값을 바꾸지 않는다는 것을 증명하세요.
--
-- 먼저 보조 함수마다 정리를 하나씩 증명하고, 그다음 simplify_correct 를
-- e 에 대한 귀납법으로 증명하세요.
--
-- 보조 함수에서는 unfold addS 가 정의의 match 를 보여 줍니다. 그다음
-- split 은 목표에 있는 match 의 경우마다 목표를 하나씩 주고, 그 경우가
-- 맞춘 것을 가정으로 줍니다. simp [eval] 이 각각을 마무리합니다.
--
-- (이렇게 일을 나누는 것은 설계의 선택입니다. 023 처럼 중첩된 match 로
-- 쓴 simplify 는 성질을 증명하기가 훨씬 어렵습니다.)

inductive Expr where
  | num (n : Nat)
  | add (a b : Expr)
  | mul (a b : Expr)

def eval : Expr → Nat
  | .num n => n
  | .add a b => eval a + eval b
  | .mul a b => eval a * eval b

def addS : Expr → Expr → Expr
  | .num 0, b => b
  | a, .num 0 => a
  | a, b => .add a b

def mulS : Expr → Expr → Expr
  | .num 1, b => b
  | a, .num 1 => a
  | a, b => .mul a b

def simplify : Expr → Expr
  | .num n => .num n
  | .add a b => addS (simplify a) (simplify b)
  | .mul a b => mulS (simplify a) (simplify b)

theorem eval_addS (a b : Expr) : eval (addS a b) = eval a + eval b := by
  sorry

theorem eval_mulS (a b : Expr) : eval (mulS a b) = eval a * eval b := by
  sorry

theorem simplify_correct (e : Expr) : eval (simplify e) = eval e := by
  sorry
