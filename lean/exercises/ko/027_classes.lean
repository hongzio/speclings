-- leanlings 027: 타입 클래스
--
-- 다형 함수는 모든 타입 α 에 대해 동작하므로, 모든 타입에서 되는 것만 할
-- 수 있습니다. 모든 타입에 == 가 있지는 않습니다. 아래 count 는 α 에
-- 대한 == 가 필요합니다. 대괄호 안의 instance 인자로 요구하세요:
--
--   def count {α : Type} [BEq α] (xs : List α) (x : α) : Nat := ...
--
-- 이제 count 는 BEq instance 가 있는 모든 타입에 대해 동작하고, 호출하는
-- 쪽은 그것을 넘기지 않습니다. Lean 이 instance 를 찾아 줍니다.
--
-- 클래스를 직접 정의할 수도 있습니다. 클래스는 instance 가 제공해야 할
-- 것을 나열합니다:
--
--   class Describe (α : Type) where
--     describe : α → String
--
-- 그러면 Describe.describe x 는 타입에 instance 가 있는 어떤 x 든
-- 설명합니다. instance 자체가 instance 를 요구할 수도 있습니다. 아래
-- List α 의 instance 는 instance 가 있는 모든 α 에 대해 동작합니다.
--
-- count 를 고치세요. 그다음 Nat 의 instance (3 이면 "the number 3"),
-- describeAll, 그리고 [true, false] 를 "[yes, no]" 로 쓰는 리스트의
-- instance 를 채우세요.

def count {α : Type} (xs : List α) (x : α) : Nat := (xs.filter (· == x)).length

#guard count [1, 2, 1] 1 == 2
#guard count ["a", "b"] "c" == 0

class Describe (α : Type) where
  describe : α → String

instance : Describe Bool where
  describe b := if b then "yes" else "no"

instance : Describe Nat where
  describe n := sorry

#guard Describe.describe (3 : Nat) == "the number 3"

def describeAll {α : Type} [Describe α] (xs : List α) : List String := sorry

#guard describeAll [true, false] == ["yes", "no"]
#guard describeAll [1, 2] == ["the number 1", "the number 2"]

instance {α : Type} [Describe α] : Describe (List α) where
  describe xs := sorry

#guard Describe.describe [true, false] == "[yes, no]"
