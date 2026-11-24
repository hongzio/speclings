-- speclings lean 052: helper lemmas
--
-- reverse below puts the first element at the end of the reversed rest.
-- Reversing twice gives the list back. Try to prove reverse_reverse by
-- induction directly: in the cons case, the goal is
--
--   reverse (append (reverse xs) [x]) = x :: xs
--
-- and the induction hypothesis, about reverse (reverse xs), does not fit.
-- That is a sign that a more general fact is needed first: how reverse
-- treats an append. Prove reverse_append, then use it.
--
-- append_nil and append_assoc, from 050, are given with their proofs:
-- use them in rw like any theorem.

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def reverse {α : Type} : List α → List α
  | [] => []
  | x :: xs => append (reverse xs) [x]

theorem append_nil {α : Type} (xs : List α) : append xs [] = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => rw [append, ih]

theorem append_assoc {α : Type} (xs ys zs : List α) :
    append (append xs ys) zs = append xs (append ys zs) := by
  induction xs with
  | nil => rfl
  | cons x xs ih => rw [append, append, append, ih]

theorem reverse_append {α : Type} (xs ys : List α) :
    reverse (append xs ys) = append (reverse ys) (reverse xs) := by
  sorry

theorem reverse_reverse {α : Type} (xs : List α) : reverse (reverse xs) = xs := by
  sorry
