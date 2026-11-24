-- leanlings 018: 구조체
--
-- structure 는 이름 붙은 값들, 곧 필드들을 하나의 값으로 묶습니다:
--
--   structure Point where
--     x : Int
--     y : Int
--
-- Point 를 만드는 방법은 세 가지이고, 모두 같은 값을 만듭니다:
--
--   { x := 1, y := 2 }     모든 필드를 이름으로
--   ⟨1, 2⟩                 필드를 순서대로 (⟨ ⟩ 는 \< 와 \> 로 입력)
--   Point.mk 1 2           Lean 이 만들어 주는 함수인 생성자로
--
-- p.x 는 p 의 필드 x 입니다. Lean 에서 값은 바뀌지 않지만, { p with
-- x := 5 } 는 x 만 다른 p 의 복사본인 새 Point 입니다.
--
-- 점 (0, 0) 인 origin 을 고치세요. 그다음 점을 오른쪽으로 dx 만큼
-- 옮기는 moveRight 와, 두 점을 필드별로 더하는 add 를 채우세요.

structure Point where
  x : Int
  y : Int

def origin : Point := { x := 0 }

#guard origin.x == 0 && origin.y == 0

def moveRight (p : Point) (dx : Int) : Point := sorry

#guard (moveRight ⟨1, 2⟩ 3).x == 4
#guard (moveRight ⟨1, 2⟩ 3).y == 2

def add (p q : Point) : Point := sorry

#guard (add ⟨1, 2⟩ ⟨3, 4⟩).x == 4
#guard (add ⟨1, 2⟩ ⟨3, 4⟩).y == 6
