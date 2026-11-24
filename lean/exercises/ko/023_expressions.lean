-- speclings lean 023: 식
--
-- 프로그램도 데이터입니다. 산술식은 수, 두 식의 합, 또는 두 식의
-- 곱입니다:
--
--   inductive Expr where
--     | num (n : Nat)
--     | add (a b : Expr)
--     | mul (a b : Expr)
--
-- 아래 sample 은 (2 + 3) * 4 를 연산의 트리로 쓴 것입니다. Part 7 에서
-- Expr 로 돌아와, 이것을 위한 작은 컴파일러가 올바르다는 것을
-- 증명합니다.
--
-- 다음을 채우세요:
--
--   eval       식의 값
--   render     식을 글로 쓴 것. 모든 + 와 * 를 괄호로 감쌉니다.
--              예: "((2 + 3) * 4)"
--   simplify   식 어디에서든 0 을 더하는 것과 1 을 곱하는 것을 없앤 같은
--              식
--
-- simplify 는 먼저 두 부분을 simplify 하세요. 그다음 두 결과에 한꺼번에
-- 매칭하세요: match simplify a, simplify b with | .num 0, b' => b' | ...

inductive Expr where
  | num (n : Nat)
  | add (a b : Expr)
  | mul (a b : Expr)
  deriving Repr, BEq

-- (2 + 3) * 4
def sample : Expr := .mul (.add (.num 2) (.num 3)) (.num 4)

def eval : Expr → Nat := sorry

#guard eval sample == 20
#guard eval (.num 7) == 7

def render : Expr → String := sorry

#guard render sample == "((2 + 3) * 4)"
#guard render (.num 7) == "7"

def simplify : Expr → Expr := sorry

#guard simplify (.add (.num 0) (.num 5)) == .num 5
#guard simplify (.mul (.add (.num 3) (.num 0)) (.num 1)) == .num 3
#guard simplify sample == sample
