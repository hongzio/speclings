-- speclings lean 013: lists
--
-- A List Nat is a sequence of Nats. Every list is either empty, [], or an
-- element in front of a list, x :: xs. [1, 2, 3] is short for
-- 1 :: 2 :: 3 :: [].
--
-- So a function on lists matches these two shapes, and calls itself on
-- the rest of the list, which is smaller:
--
--   def doubleAll : List Nat → List Nat
--     | [] => []
--     | x :: xs => (x * 2) :: doubleAll xs
--
-- ++ joins two lists: [1, 2] ++ [3] is [1, 2, 3].
--
-- Fill in len (the number of elements), total (their sum) and has
-- (whether a number is in the list) with pattern matching and recursion.
-- Lists have these functions already (length, sum, contains), but this
-- exercise is about writing them: it does not accept those, or foldl,
-- foldr, elem and any.

def len : List Nat → Nat := sorry

#guard len [] == 0
#guard len [5, 6, 7] == 3

def total : List Nat → Nat := sorry

#guard total [] == 0
#guard total [1, 2, 3, 4] == 10

def has (xs : List Nat) (y : Nat) : Bool := sorry

#guard has [1, 2, 3] 2
#guard !has [1, 2, 3] 5
#guard !has [] 0
