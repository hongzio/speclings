-- speclings lean 054: finding lemmas (solution)

theorem len_append (xs ys : List Nat) : (xs ++ ys).length = xs.length + ys.length := by
  exact List.length_append

theorem rev_rev (xs : List Nat) : xs.reverse.reverse = xs := by
  exact List.reverse_reverse xs

theorem len_map (f : Nat → Nat) (xs : List Nat) : (xs.map f).length = xs.length := by
  exact List.length_map f

theorem lt_le (a b : Nat) (h : a < b) : a ≤ b := by
  exact Nat.le_of_lt h

theorem sub_then_add (a b : Nat) (h : b ≤ a) : a - b + b = a := by
  exact Nat.sub_add_cancel h

theorem len_rev_append (xs ys : List Nat) : (xs ++ ys).reverse.length = ys.length + xs.length := by
  rw [List.length_reverse, List.length_append, Nat.add_comm]
