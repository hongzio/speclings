-- speclings lean 054: generalizing (solution)

def sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs

def sumAcc : List Nat → Nat → Nat
  | [], acc => acc
  | x :: xs, acc => sumAcc xs (acc + x)

def sumTR (xs : List Nat) : Nat := sumAcc xs 0

theorem sumAcc_eq (xs : List Nat) (acc : Nat) : sumAcc xs acc = acc + sum xs := by
  induction xs generalizing acc with
  | nil => simp [sumAcc, sum]
  | cons x xs ih => simp [sumAcc, sum, ih]; omega

theorem sumTR_eq (xs : List Nat) : sumTR xs = sum xs := by
  simp [sumTR, sumAcc_eq]

def revAcc : List Nat → List Nat → List Nat
  | [], acc => acc
  | x :: xs, acc => revAcc xs (x :: acc)

theorem revAcc_eq (xs acc : List Nat) : revAcc xs acc = xs.reverse ++ acc := by
  induction xs generalizing acc with
  | nil => simp [revAcc]
  | cons x xs ih => simp [revAcc, ih]
