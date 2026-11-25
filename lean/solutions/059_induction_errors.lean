-- speclings lean 059: debugging induction (solution)

def lenAcc : List Nat → Nat → Nat
  | [], acc => acc
  | _ :: xs, acc => lenAcc xs (acc + 1)

theorem lenAcc_eq (xs : List Nat) (acc : Nat) : lenAcc xs acc = acc + xs.length := by
  induction xs generalizing acc with
  | nil => simp [lenAcc]
  | cons x xs ih => simp [lenAcc, ih]; omega

theorem lenAcc_zero (xs : List Nat) : lenAcc xs 0 = xs.length := by
  simp [lenAcc_eq]

def double : Nat → Nat
  | 0 => 0
  | n + 1 => double n + 2

theorem double_pos (n : Nat) (h : 0 < n) : 0 < double n := by
  cases n with
  | zero => omega
  | succ k => rw [double]; omega

def IsEven (n : Nat) : Prop := n % 2 = 0

theorem even_add_two (n : Nat) (h : IsEven n) : IsEven (n + 2) := by
  unfold IsEven at *
  omega
