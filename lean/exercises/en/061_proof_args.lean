-- speclings lean 061: proofs as arguments
--
-- 015 showed that List.head needs a proof that the list is not empty:
--
--   List.head : (xs : List α) → xs ≠ [] → α
--
-- Your own functions can ask for proofs the same way, instead of
-- returning an Option. Then they never fail, and the caller has to show
-- that the input is fine:
--
--   firstAndLast [3, 1, 4] (by simp)
--
-- A function that has such a proof can pass it on, or build a new one
-- from it: with h : xs.length > 5, the proof that xs.length ≥ 2 is
-- (by omega). And when it reads xs[i], Lean looks for the proof that i is
-- small enough among the hypotheses.
--
-- Useful here: xs.head h and xs.getLast h, for h : xs ≠ [].

def firstAndLast (xs : List Nat) (h : xs ≠ []) : Nat × Nat := sorry

#guard firstAndLast [3, 1, 4] (by simp) == (3, 4)

def second (xs : List Nat) (h : xs.length ≥ 2) : Nat := sorry

#guard second [5, 6, 7] (by decide) == 6

def middle (xs : List Nat) (h : xs.length > 0) : Nat := sorry

#guard middle [1, 2, 3] (by decide) == 2

-- use second
def secondOfLong (xs : List Nat) (h : xs.length > 5) : Nat := sorry

#guard secondOfLong [1, 2, 3, 4, 5, 6] (by decide) == 2
