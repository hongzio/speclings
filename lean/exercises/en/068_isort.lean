-- leanlings 068: insertion sort
--
-- isort sorts a list by inserting its elements, one by one, into a sorted
-- list. Its result is sorted: that follows from ins_sorted (067, given).
--
-- But is "the result is sorted" a good specification? badSort below
-- always returns [], which is sorted too. A sort must also keep the
-- elements: the result must be a permutation of the input, the same
-- elements in some order. The library defines that as List.Perm, written
-- l₁.Perm l₂, with rules such as:
--
--   List.Perm.refl l : l.Perm l
--   h.cons x : (x :: l₁).Perm (x :: l₂)      for h : l₁.Perm l₂
--   List.Perm.swap x y l : (y :: x :: l).Perm (x :: y :: l)
--   h₁.trans h₂ : l₁.Perm l₃       for h₁ : l₁.Perm l₂ and h₂ : l₂.Perm l₃
--   h.length_eq : l₁.length = l₂.length
--
-- Prove that isort is sorted and a permutation, and that badSort is not a
-- permutation. For ins_perm, the case where x goes after y is
-- y :: ins x ys, which is a permutation of y :: x :: ys, which is one of
-- x :: y :: ys.

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
  sorry

theorem ins_perm (x : Nat) (xs : List Nat) : (ins x xs).Perm (x :: xs) := by
  sorry

theorem isort_perm (xs : List Nat) : (isort xs).Perm xs := by
  sorry

def badSort (_ : List Nat) : List Nat := []

theorem badSort_sorted (xs : List Nat) : Sorted (badSort xs) := .nil

theorem badSort_not_perm : ¬ (badSort [1]).Perm [1] := by
  sorry
