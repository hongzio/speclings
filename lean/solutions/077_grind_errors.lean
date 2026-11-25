-- speclings lean 077: when grind fails (solution)

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => 1 + len xs

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  induction xs <;> grind [append, len]

def ins (x : Nat) : List Nat → List Nat
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: ins x ys

theorem ins_length (x : Nat) (xs : List Nat) : (ins x xs).length = xs.length + 1 := by
  induction xs <;> grind [ins]

def sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs

theorem sum_append (xs ys : List Nat) : sum (xs ++ ys) = sum xs + sum ys := by
  induction xs <;> grind [sum]

theorem sum_reverse (xs : List Nat) : sum xs.reverse = sum xs := by
  induction xs <;> grind [sum, sum_append]
