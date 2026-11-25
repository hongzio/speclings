-- speclings lean 051: induction on lists
--
-- Induction works on any inductive type, with one case per constructor.
-- For lists:
--
--   induction xs with
--   | nil => ...              -- prove it for []
--   | cons x xs ih => ...     -- prove it for x :: xs, with ih for xs
--
-- append and len below are written from scratch, so the library's
-- theorems about ++ and length do not apply to them: you prove their
-- properties yourself.
--
-- rw [append] rewrites with an equation of the definition of append,
-- whichever fits the goal: append (x :: xs) ys becomes x :: append xs ys.
-- It is one step of computing, by hand.
--
-- For len_append, two theorems about Nat help:
--
--   Nat.zero_add n : 0 + n = n
--   Nat.add_right_comm a b c : a + b + c = a + c + b

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => len xs + 1

theorem append_nil {α : Type} (xs : List α) : append xs [] = xs := by
  sorry

theorem append_assoc {α : Type} (xs ys zs : List α) :
    append (append xs ys) zs = append xs (append ys zs) := by
  sorry

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  sorry
