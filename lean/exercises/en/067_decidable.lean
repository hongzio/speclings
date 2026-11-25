-- speclings lean 067: decidable statements
--
-- if c then ... and #guard c need more than a statement c: they need a way
-- to compute whether c holds. That is an instance of Decidable c. Lean has
-- them for =, < and the like on Nat, and for ∧, ∨, ¬ of decidable
-- statements. For a statement you define, Lean does not look inside the
-- definition: you give the instance.
--
-- When the definition is already decidable, inferInstanceAs tells Lean to
-- use the instance of what it unfolds to:
--
--   instance (n : Nat) : Decidable (Even n) := inferInstanceAs (Decidable (n % 2 = 0))
--
-- Otherwise, a common way is to write a Bool function that computes the
-- answer, prove that it agrees with the statement, and turn that into an
-- instance:
--
--   decidable_of_iff _ (isSorted_iff xs) : Decidable (Sorted xs)
--
-- Fill in the instance for Even, isSorted, the proof that it agrees with
-- Sorted (fun_induction, then simp_all), and the instance for Sorted.

def Even (n : Nat) : Prop := n % 2 = 0

instance (n : Nat) : Decidable (Even n) := sorry

#guard Even 4
#guard ¬ Even 7

def evens (xs : List Nat) : List Nat := xs.filter (fun n => decide (Even n))

#guard evens [1, 2, 3, 4] == [2, 4]

def Sorted : List Nat → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a ≤ b ∧ Sorted (b :: rest)

def isSorted : List Nat → Bool := sorry

theorem isSorted_iff (xs : List Nat) : isSorted xs = true ↔ Sorted xs := by
  sorry

instance : DecidablePred Sorted := sorry

#guard Sorted [1, 2, 2, 5]
#guard ¬ Sorted [3, 1]
