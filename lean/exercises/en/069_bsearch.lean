-- speclings lean 069: binary search
--
-- This is the bsearch of 065. Prove that it is sound: when it returns a
-- position, x is there.
--
-- bsearch is not structurally recursive, so fun_induction (056) is the
-- way in: it gives one case per branch of the definition, with an
-- induction hypothesis for each recursive call.
--
--   case1   a[mid] = x, and the result is some ⟨mid, _⟩
--   case2   a[mid] < x: the search goes on to the right
--   case3   otherwise: the search goes on to the left
--   case4   lo ≥ hi, and the result is none
--
-- In case1, the hypothesis says some ⟨mid, _⟩ = some i. cases on it
-- replaces i with ⟨mid, _⟩. In case4, none = some i is impossible: simp
-- at it closes the goal.
--
-- find_sound follows: case on what bsearch returned (cases hb : ...), and
-- use bsearch_sound.
--
-- Completeness, that bsearch finds x whenever x is in a sorted array, is
-- true too, but much harder to prove: it needs to know where x can be.

def bsearch (a : Array Nat) (x : Nat) (lo hi : Nat) (h : hi ≤ a.size) : Option (Fin a.size) :=
  if hlt : lo < hi then
    let mid := (lo + hi) / 2
    if a[mid] = x then some ⟨mid, by omega⟩
    else if a[mid] < x then bsearch a x (mid + 1) hi h
    else bsearch a x lo mid (by omega)
  else none
termination_by hi - lo

def find (a : Array Nat) (x : Nat) : Option Nat :=
  (bsearch a x 0 a.size (Nat.le_refl _)).map (·.val)

theorem bsearch_sound (a : Array Nat) (x lo hi : Nat) (h : hi ≤ a.size) (i : Fin a.size)
    (hs : bsearch a x lo hi h = some i) : a[i] = x := by
  sorry

theorem find_sound (a : Array Nat) (x i : Nat) (h : find a x = some i) : a[i]? = some x := by
  sorry
