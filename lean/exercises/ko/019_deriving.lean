-- leanlings 019: deriving
--
-- 018 의 #guard 는 점을 필드별로 비교했습니다. Point 두 개를 == 로
-- 비교하려면 Point 를 비교하는 방법, 곧 BEq Point 의 instance 가
-- 필요합니다. Lean 은 그것을 스스로 만들지는 않지만, 필드 뒤에 deriving
-- 으로 요청하면 만들어 줍니다:
--
--   structure Point where
--     x : Int
--     y : Int
--     deriving BEq, Repr
--
-- 이렇게 만든 == 는 필드를 하나씩 비교합니다. Repr 은 #eval 이 값을
-- 보여 주는 방법입니다. (#eval 은 Repr 없이도 구조체를 보여 주지만, 다른
-- 명령에는 필요합니다.)
--
-- 에러를 읽어 보세요. Hint 가 고치는 방법도 알려 줍니다. 그다음 점의
-- 좌표를 맞바꾸는 swapXY 를 채우세요.

structure Point where
  x : Int
  y : Int

def p : Point := ⟨1, 2⟩

#eval p

#guard p == ⟨1, 2⟩
#guard p != ⟨2, 1⟩

def swapXY (p : Point) : Point := sorry

#guard swapXY p == ⟨2, 1⟩
