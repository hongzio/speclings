-- speclings lean 027: type classes
--
-- A polymorphic function works for every type α, so it may only do what
-- works for every type. Not every type has ==: count below needs one for
-- α. Ask for it with an instance argument in square brackets:
--
--   def count {α : Type} [BEq α] (xs : List α) (x : α) : Nat := ...
--
-- Now count works for every type that has an instance of BEq, and
-- callers do not pass it: Lean finds the instance.
--
-- You can define your own classes too. A class lists what an instance has
-- to provide:
--
--   class Describe (α : Type) where
--     describe : α → String
--
-- Describe.describe x then describes x, for any x whose type has an
-- instance. An instance can itself need instances: the one for List α
-- below works for every α that has one.
--
-- Fix count. Then fill in the instance for Nat ("the number 3" for 3),
-- describeAll, and the instance for lists, which writes "[yes, no]" for
-- [true, false].

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
