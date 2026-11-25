-- speclings lean 069: grind (solution)

def sumTo : Nat → Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo n

theorem gauss (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  induction n with
  | zero => rfl
  | succ n ih => grind [sumTo]

theorem square_sum (a b : Nat) : (a + b) * (a + b) = a * a + 2 * a * b + b * b := by
  grind

theorem odd_succ (x : Nat) (h : x % 2 = 1) : (x + 1) % 2 = 0 := by
  grind

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => len xs + 1

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  induction xs <;> grind [append, len]
