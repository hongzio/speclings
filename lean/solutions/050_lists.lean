-- leanlings 050: induction on lists (solution)

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => len xs + 1

theorem append_nil {α : Type} (xs : List α) : append xs [] = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => rw [append, ih]

theorem append_assoc {α : Type} (xs ys zs : List α) :
    append (append xs ys) zs = append xs (append ys zs) := by
  induction xs with
  | nil => rfl
  | cons x xs ih => rw [append, append, append, ih]

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  induction xs with
  | nil => rw [append, len, Nat.zero_add]
  | cons x xs ih => rw [append, len, len, ih, Nat.add_right_comm]
