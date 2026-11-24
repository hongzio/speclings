-- speclings lean 068: insertion sort (solution)

inductive Sorted : List Nat → Prop where
  | nil : Sorted []
  | single (x : Nat) : Sorted [x]
  | cons {x y : Nat} {ys : List Nat} : x ≤ y → Sorted (y :: ys) → Sorted (x :: y :: ys)

def ins (x : Nat) : List Nat → List Nat
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: ins x ys

theorem ins_sorted (x : Nat) (xs : List Nat) (h : Sorted xs) : Sorted (ins x xs) := by
  induction h <;> grind [ins, Sorted.nil, Sorted.single, Sorted.cons]

def isort : List Nat → List Nat
  | [] => []
  | x :: xs => ins x (isort xs)

theorem isort_sorted (xs : List Nat) : Sorted (isort xs) := by
  induction xs with
  | nil => exact .nil
  | cons x xs ih => exact ins_sorted x _ ih

theorem ins_perm (x : Nat) (xs : List Nat) : (ins x xs).Perm (x :: xs) := by
  induction xs with
  | nil => exact .refl _
  | cons y ys ih =>
    unfold ins
    split
    · exact .refl _
    · exact (ih.cons y).trans (.swap x y ys)

theorem isort_perm (xs : List Nat) : (isort xs).Perm xs := by
  induction xs with
  | nil => exact .refl _
  | cons x xs ih => exact (ins_perm x _).trans (ih.cons x)

def badSort (_ : List Nat) : List Nat := []

theorem badSort_sorted (xs : List Nat) : Sorted (badSort xs) := .nil

theorem badSort_not_perm : ¬ (badSort [1]).Perm [1] := by
  intro h
  have := h.length_eq
  simp [badSort] at this
