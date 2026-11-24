-- speclings lean 016: pairs
--
-- A pair holds two values, of the same or different types. The type of a
-- pair is written with × (type \x):
--
--   (3, "three") : Nat × String
--
-- p.1 and p.2 (or p.fst and p.snd) are its parts, and let or fun can take
-- a pair apart:
--
--   let (q, r) := (7 / 2, 7 % 2)
--   fun (a, b) => a + b
--
-- zip pairs up two lists: [1, 2].zip ["a", "b"] is [(1, "a"), (2, "b")].
--
-- Fill in divMod (the quotient and the remainder), swap, sumPairs (the sum
-- of each pair) and indexed (each element with its position).

def divMod (a b : Nat) : Nat × Nat := sorry

#guard divMod 7 2 == (3, 1)

def swap (p : Nat × String) : String × Nat := sorry

#guard swap (1, "one") == ("one", 1)

def sumPairs (xs : List (Nat × Nat)) : List Nat := sorry

#guard sumPairs [(1, 2), (3, 4)] == [3, 7]

def indexed (xs : List String) : List (Nat × String) := sorry

#guard indexed ["a", "b", "c"] == [(0, "a"), (1, "b"), (2, "c")]
