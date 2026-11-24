-- speclings lean 053: simp and omega (solution)

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => len xs + 1

theorem shuffle (a b c d : Nat) (h1 : a < b) (h2 : c ≤ d) : a + c < b + d + 1 := by
  omega

theorem reverse_sum (a b c : Nat) : a + b + c = c + b + a := by
  omega

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  induction xs with
  | nil => simp [append, len]
  | cons x xs ih => simp [append, len, ih]; omega

@[simp] theorem append_nil {α : Type} (xs : List α) : append xs [] = xs := by
  induction xs <;> simp [append, *]

theorem len_append_nil (xs : List Nat) : len (append xs []) = len xs := by
  simp
