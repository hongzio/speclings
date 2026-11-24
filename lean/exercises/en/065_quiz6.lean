-- speclings lean 065: quiz 6
--
-- Binary search finds a number in a sorted array by halving the part
-- where it can be. bsearch a x lo hi searches the positions lo .. hi - 1
-- and returns the position of x, if it is there. The position comes as a
-- Fin a.size, so it can be used as an index without further proof.
--
-- Write bsearch:
--
--   - if lo < hi, look at mid := (lo + hi) / 2: return it if a[mid] = x,
--     otherwise search the half where x can be
--   - otherwise, x is not there
--
-- You will need: a dependent if (if hlt : lo < hi), so that Lean can prove
-- that mid is a valid index (h : hi ≤ a.size helps too); proofs that the
-- new hi is still at most a.size; and termination_by hi - lo. omega does
-- the arithmetic, and Lean tries it on its own for the indices and the
-- termination.
--
-- Part 7 proves that bsearch finds x whenever x is in a sorted array.

def bsearch (a : Array Nat) (x : Nat) (lo hi : Nat) (h : hi ≤ a.size) : Option (Fin a.size) :=
  sorry

def find (a : Array Nat) (x : Nat) : Option Nat :=
  (bsearch a x 0 a.size (Nat.le_refl _)).map (·.val)

#guard find #[1, 3, 5, 7, 9] 7 == some 3
#guard find #[1, 3, 5, 7, 9] 1 == some 0
#guard find #[1, 3, 5, 7, 9] 9 == some 4
#guard find #[1, 3, 5, 7, 9] 4 == none
#guard find #[] 4 == none
