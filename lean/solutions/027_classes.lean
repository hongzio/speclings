-- speclings lean 027: type classes (solution)

def count {α : Type} [BEq α] (xs : List α) (x : α) : Nat := (xs.filter (· == x)).length

#guard count [1, 2, 1] 1 == 2
#guard count ["a", "b"] "c" == 0

class Describe (α : Type) where
  describe : α → String

instance : Describe Bool where
  describe b := if b then "yes" else "no"

instance : Describe Nat where
  describe n := s!"the number {n}"

#guard Describe.describe (3 : Nat) == "the number 3"

def describeAll {α : Type} [Describe α] (xs : List α) : List String := xs.map Describe.describe

#guard describeAll [true, false] == ["yes", "no"]
#guard describeAll [1, 2] == ["the number 1", "the number 2"]

instance {α : Type} [Describe α] : Describe (List α) where
  describe xs := "[" ++ ", ".intercalate (describeAll xs) ++ "]"

#guard Describe.describe [true, false] == "[yes, no]"
