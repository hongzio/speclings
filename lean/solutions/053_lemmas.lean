-- speclings lean 053: helper lemmas (solution)

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
  induction xs with
  | nil => rw [append, reverse, append_nil]
  | cons x xs ih => rw [append, reverse, reverse, ih, append_assoc]

theorem reverse_reverse {α : Type} (xs : List α) : reverse (reverse xs) = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => rw [reverse, reverse_append, ih]; rfl
