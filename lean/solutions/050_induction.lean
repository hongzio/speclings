-- speclings lean 050: induction (solution)

def add : Nat → Nat → Nat
  | m, 0 => m
  | m, n + 1 => add m n + 1

theorem add_zero' (m : Nat) : add m 0 = m := rfl

theorem add_succ' (m n : Nat) : add m (n + 1) = add m n + 1 := rfl

theorem zero_add' (n : Nat) : add 0 n = n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [add_succ', ih]

theorem succ_add' (m n : Nat) : add (m + 1) n = add m n + 1 := by
  induction n with
  | zero => rfl
  | succ n ih => rw [add_succ', add_succ', ih]

theorem add_comm' (m n : Nat) : add m n = add n m := by
  induction n with
  | zero => rw [add_zero', zero_add']
  | succ n ih => rw [add_succ', succ_add', ih]
