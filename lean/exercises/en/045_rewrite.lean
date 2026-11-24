-- leanlings 045: rewriting
--
-- With h : a = b, rw [h] replaces every a in the goal with b. rw [← h]
-- (type ← as \l) replaces b with a. rw [h1, h2] rewrites with h1, then
-- h2. When the goal becomes something of the form x = x, rw closes it.
--
-- Theorems of the library rewrite too. A few about Nat:
--
--   Nat.add_zero n : n + 0 = n
--   Nat.add_comm a b : a + b = b + a
--   Nat.add_assoc a b c : a + b + c = a + (b + c)
--   Nat.add_sub_cancel : n + m - m = n
--
-- Give arguments to pick which part to rewrite: rw [Nat.add_comm a b]
-- rewrites a + b only, while rw [Nat.add_comm] rewrites the first sum
-- Lean finds. (#check Nat.add_comm shows a theorem's statement.)

theorem eq_chain (a b c : Nat) (h1 : a = b) (h2 : b = c) : a = c := by
  sorry

theorem plus_zero (a b : Nat) (h : a = b + 1) : a + 0 = b + 1 := by
  sorry

theorem apply_both (f : Nat → Nat) (a b : Nat) (h : a = b) : f a = f b := by
  sorry

theorem reverse_sum (a b c : Nat) : a + b + c = c + b + a := by
  sorry

theorem undo_succ (a b : Nat) (h : a + 1 = b) : b - 1 = a := by
  sorry
