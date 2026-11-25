-- speclings lean 072: writing specifications (solution)

def IsMax (xs : List Nat) (m : Nat) : Prop :=
  m ∈ xs ∧ ∀ x ∈ xs, x ≤ m

theorem max_example : IsMax [3, 1, 2] 3 := by
  unfold IsMax; decide

theorem max_not_bound : ¬ IsMax [3, 1, 2] 5 := by
  unfold IsMax; decide

theorem max_not_largest : ¬ IsMax [3, 1, 2] 1 := by
  unfold IsMax; decide

theorem max_nil (m : Nat) : ¬ IsMax [] m := by
  simp [IsMax]

def maxOf (x : Nat) : List Nat → Nat
  | [] => x
  | y :: ys => maxOf (max x y) ys

theorem maxOf_ge (x : Nat) (xs : List Nat) : x ≤ maxOf x xs := by
  induction xs generalizing x <;> grind [maxOf]

theorem maxOf_mem (x : Nat) (xs : List Nat) : maxOf x xs ∈ x :: xs := by
  induction xs generalizing x <;> grind [maxOf]

theorem maxOf_bound (x : Nat) (xs : List Nat) : ∀ y ∈ x :: xs, y ≤ maxOf x xs := by
  induction xs generalizing x <;> grind [maxOf, maxOf_ge]

theorem maxOf_isMax (x : Nat) (xs : List Nat) : IsMax (x :: xs) (maxOf x xs) :=
  ⟨maxOf_mem x xs, maxOf_bound x xs⟩

def IsDedup (xs ys : List Nat) : Prop :=
  ys.Nodup ∧ (∀ y ∈ ys, y ∈ xs) ∧ (∀ x ∈ xs, x ∈ ys)

theorem dedup_example : IsDedup [1, 2, 1, 3] [1, 2, 3] := by
  unfold IsDedup; decide

theorem dedup_any_order : IsDedup [1, 2, 1, 3] [3, 1, 2] := by
  unfold IsDedup; decide

theorem dedup_not_empty : ¬ IsDedup [1, 2, 1] [] := by
  unfold IsDedup; decide

theorem dedup_not_same : ¬ IsDedup [1, 2, 1] [1, 2, 1] := by
  unfold IsDedup; decide

theorem dedup_not_new : ¬ IsDedup [1, 2] [1, 2, 3] := by
  unfold IsDedup; decide
