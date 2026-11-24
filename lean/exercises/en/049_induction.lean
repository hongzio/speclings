-- leanlings 049: induction
--
-- Part 5 proves things about recursive functions. Here is addition,
-- written from scratch: add m n adds 1 to m, n times.
--
--   add m 0 = m
--   add m (n + 1) = add m n + 1
--
-- Both equations hold by definition, so rfl proves them (they are given
-- below as add_zero' and add_succ'). But add 0 n = n is different: n is
-- unknown, so Lean cannot compute add 0 n. It needs a proof for every n,
-- and that is what induction gives:
--
--   induction n with
--   | zero => ...           -- prove it for 0
--   | succ n ih => ...      -- prove it for n + 1, using ih: it holds for n
--
-- Like a recursive function, the proof for n + 1 may use the proof for n.
-- rw [add_succ'] rewrites with a given equation, and then rw [ih] with
-- the induction hypothesis.
--
-- succ_add' and add_comm' use the same idea; add_comm' also needs the
-- theorems proved before it. Automatic tactics are still not accepted.

def add : Nat → Nat → Nat
  | m, 0 => m
  | m, n + 1 => add m n + 1

theorem add_zero' (m : Nat) : add m 0 = m := rfl

theorem add_succ' (m n : Nat) : add m (n + 1) = add m n + 1 := rfl

theorem zero_add' (n : Nat) : add 0 n = n := by
  sorry

theorem succ_add' (m n : Nat) : add (m + 1) n = add m n + 1 := by
  sorry

theorem add_comm' (m n : Nat) : add m n = add n m := by
  sorry
