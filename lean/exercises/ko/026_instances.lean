-- speclings lean 026: instance
--
-- 연산자는 타입 클래스의 함수입니다. a + b 는 HAdd.hAdd a b 라는 뜻이고,
-- Lean 은 이 타입들의 값 두 개를 더하는 방법을 말해 주는 instance 를
-- 찾습니다. Nat 과 Int 의 instance 는 Lean 에 들어 있습니다. 여러분이
-- 만든 타입의 instance 는 직접 씁니다:
--
--   instance : Add Point where
--     add p q := ...
--
-- (Lean 은 Add Point 로부터 HAdd Point Point Point 를 얻습니다.) 다른
-- 클래스도 마찬가지입니다. ToString Point 는 Point 를 String 으로 바꾸는
-- 방법이고, s!"{p}" 와 toString p 가 이것을 씁니다.
--
-- shift 는 그대로 두고, 그 앞에 Add Point 의 instance 를 더해서 고치세요.
-- 그다음 ToString instance 를 채우세요. x = 1, y = 2 인 점은 (1, 2) 입니다.

structure Point where
  x : Int
  y : Int
  deriving BEq, Repr

def shift (p q : Point) : Point := p + q

#guard shift ⟨1, 2⟩ ⟨3, 4⟩ == ⟨4, 6⟩
#guard (⟨1, 2⟩ : Point) + ⟨10, 20⟩ == ⟨11, 22⟩

instance : ToString Point where
  toString p := sorry

#guard s!"{(⟨1, 2⟩ : Point)}" == "(1, 2)"
#guard toString (⟨-1, 0⟩ : Point) == "(-1, 0)"
