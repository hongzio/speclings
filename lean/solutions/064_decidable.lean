-- speclings lean 064: decidable statements (solution)

def Even (n : Nat) : Prop := n % 2 = 0

instance (n : Nat) : Decidable (Even n) := inferInstanceAs (Decidable (n % 2 = 0))

#guard Even 4
#guard ¬ Even 7

def evens (xs : List Nat) : List Nat := xs.filter (fun n => decide (Even n))

#guard evens [1, 2, 3, 4] == [2, 4]

def Sorted : List Nat → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a ≤ b ∧ Sorted (b :: rest)

def isSorted : List Nat → Bool
  | [] => true
  | [_] => true
  | a :: b :: rest => a ≤ b && isSorted (b :: rest)

theorem isSorted_iff (xs : List Nat) : isSorted xs = true ↔ Sorted xs := by
  fun_induction isSorted xs <;> simp_all [Sorted]

instance : DecidablePred Sorted := fun xs => decidable_of_iff _ (isSorted_iff xs)

#guard Sorted [1, 2, 2, 5]
#guard ¬ Sorted [3, 1]
