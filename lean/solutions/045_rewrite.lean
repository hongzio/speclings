-- leanlings 045: rewriting (solution)

theorem eq_chain (a b c : Nat) (h1 : a = b) (h2 : b = c) : a = c := by
  rw [h1, h2]

theorem plus_zero (a b : Nat) (h : a = b + 1) : a + 0 = b + 1 := by
  rw [Nat.add_zero, h]

theorem apply_both (f : Nat → Nat) (a b : Nat) (h : a = b) : f a = f b := by
  rw [h]

theorem reverse_sum (a b c : Nat) : a + b + c = c + b + a := by
  rw [Nat.add_comm (a + b) c, Nat.add_comm a b, Nat.add_assoc]

theorem undo_succ (a b : Nat) (h : a + 1 = b) : b - 1 = a := by
  rw [← h, Nat.add_sub_cancel]
