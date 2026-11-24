-- leanlings 008: if 와 let
--
-- if c then a else b 는 식입니다. c 가 성립하면 값이 a 이고, 아니면 b
-- 입니다. 모든 식에는 값이 있어야 하므로 if 에는 else 가 필요합니다.
--
--   def larger (a b : Nat) : Nat := if a < b then b else a
--
-- 조건 c 는 Bool 이거나, a < b 처럼 Lean 이 판정할 수 있는 Prop 입니다.
--
-- let 은 중간 값에 이름을 붙입니다. 그 이름은 다음 줄부터 쓸 수
-- 있습니다:
--
--   def perimeter (w h : Nat) : Nat :=
--     let half := w + h
--     2 * half
--
-- abs 를 고치세요. 그다음 clamp 를 채우세요. clamp lo hi x 는 x 이되,
-- lo 이상이고 hi 이하여야 합니다. (let 을 한두 개 쓰면 읽기 쉽습니다.)

def abs (x : Int) : Int := if x < 0 then -x

#guard abs (-3) == 3
#guard abs 4 == 4

def clamp (lo hi x : Int) : Int := sorry

#guard clamp 0 10 5 == 5
#guard clamp 0 10 (-5) == 0
#guard clamp 0 10 15 == 10
