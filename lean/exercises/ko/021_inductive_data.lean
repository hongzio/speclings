-- leanlings 021: 데이터를 담는 생성자
--
-- 생성자는 데이터를 담을 수 있습니다. 아래 Shape 는 한 변이 있는
-- 정사각형, 가로와 세로가 있는 직사각형, 또는 밑변과 높이가 있는
-- 삼각형입니다:
--
--   .square 3        .rect 2 5        .triangle 4 3
--
-- Shape 에 대한 match 는 생성자마다 한 경우이고, 각 경우는 담긴 데이터에
-- 이름을 붙입니다:
--
--   | .rect w h => ...
--
-- (structure 는 생성자가 하나뿐인 inductive 타입입니다. Shape 는 생성자가
-- 셋이므로, Shape 값은 정확히 그중 하나입니다.)
--
-- area (삼각형은 밑변 * 높이의 절반), 모든 길이에 k 를 곱하는 scale,
-- isSquare 를 채우세요. 두 변이 같은 직사각형도 정사각형입니다.

inductive Shape where
  | square (side : Nat)
  | rect (width height : Nat)
  | triangle (base height : Nat)
  deriving Repr, BEq

def area : Shape → Nat := sorry

#guard area (.square 3) == 9
#guard area (.rect 2 5) == 10
#guard area (.triangle 4 3) == 6

def scale (k : Nat) : Shape → Shape := sorry

#guard scale 2 (.rect 2 5) == .rect 4 10
#guard scale 3 (.square 1) == .square 3

def isSquare : Shape → Bool := sorry

#guard isSquare (.square 3)
#guard isSquare (.rect 2 2)
#guard !isSquare (.rect 2 3)
#guard !isSquare (.triangle 2 2)
