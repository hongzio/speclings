-- leanlings 032: arrays
--
-- An Array is like a List, but stored in one block of memory, so reading
-- any position is fast. Arrays are written #[1, 2, 3].
--
--   a.size          the number of elements
--   a.push x        a with x added at the end
--   a[i]?           some element at position i, or none if there is none
--   a[i]!           the element at position i; stops the program if there
--                   is none (a[i] alone needs a proof that i < a.size,
--                   like List.head in 015)
--   a.modify i f    a with f applied to the element at position i
--   Array.replicate n x     n copies of x
--
-- Values never change, so a.push x is a new array. But when nothing else
-- uses a anymore, Lean reuses its memory: a loop of pushes is as fast as
-- in an imperative language.
--
-- Fill in squaresArray (with push in a loop), get (0 when i is out of
-- range) and histogram: how many times each number below buckets occurs
-- in xs. Numbers from buckets on are ignored.

def squaresArray (n : Nat) : Array Nat := sorry

#guard squaresArray 4 == #[0, 1, 4, 9]
#guard squaresArray 0 == #[]

def get (a : Array Nat) (i : Nat) : Nat := sorry

#guard get #[10, 20] 1 == 20
#guard get #[10, 20] 5 == 0

def histogram (xs : List Nat) (buckets : Nat) : Array Nat := sorry

#guard histogram [0, 1, 1, 3, 1] 4 == #[1, 3, 0, 1]
#guard histogram [5, 0] 2 == #[1, 0]
