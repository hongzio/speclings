-- leanlings 033: 에러
--
-- Option 은 "값이 없음" 을 말합니다. Except ε α 는 이유도 말합니다. 값은
-- x : α 인 .ok x 이거나, e : ε 인 .error e 이고, e 는 흔히 메시지
-- String 입니다.
--
--   throw e     에러 e (Except 에서는 .error e)
--   pure x      값 x (.ok x)
--
-- do 블록 안의 ← 는 첫 에러에서 멈추고 그 에러를 돌려줍니다. 그래서
-- 잘 되는 경우만 검사 없이 읽히게 쓸 수 있습니다:
--
--   def both (a b : String) : Except String (Nat × Nat) := do
--     let x ← parseAge a     -- 여기서 에러가 나면 both 도 그 에러로 끝남
--     let y ← parseAge b
--     return (x, y)
--
-- xs.mapM f 는 모든 원소에 f 를 적용하고, 첫 에러에서 멈춥니다.
-- s.toNat? 는 String 에서 Nat 을 읽습니다: "42".toNat? 는 some 42.
--
-- (Except 에는 == 가 없습니다. #guard 가 결과를 비교할 수 있도록 아래 첫
-- 줄이 == 를 만들어 줍니다.)
--
-- parseAge, averageAge, parseAll 을 채우세요. parseAge 는 수가 아닌 것과
-- 150 을 넘는 나이를 #guard 에 있는 메시지로 거부합니다.

deriving instance BEq for Except

def parseAge (s : String) : Except String Nat := sorry

#guard parseAge "42" == .ok 42
#guard parseAge "x" == .error "not a number: x"
#guard parseAge "200" == .error "too old: 200"

def averageAge (a b : String) : Except String Nat := sorry

#guard averageAge "20" "40" == .ok 30
#guard averageAge "20" "y" == .error "not a number: y"

def parseAll (xs : List String) : Except String (List Nat) := sorry

#guard parseAll ["1", "2"] == .ok [1, 2]
#guard parseAll ["1", "x", "y"] == .error "not a number: x"
