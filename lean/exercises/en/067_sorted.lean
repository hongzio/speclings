-- leanlings 067: a specification
--
-- To prove a program correct, first say what correct means: a
-- specification. For sorting, part of it is that the result is sorted.
-- Here Sorted is defined by rules, as an inductive predicate: its
-- constructors are the ways to prove that a list is sorted.
--
--   Sorted.nil       [] is sorted
--   Sorted.single    [x] is sorted
--   Sorted.cons      if x ≤ y and y :: ys is sorted, so is x :: y :: ys
--
-- A proof of Sorted [1, 2, 3] is built from the rules, like a value from
-- constructors. Taking a proof h : Sorted xs apart (cases h) gives the
-- rule it was built with, and its premises.
--
-- And induction h does induction on how h was built: one case per rule,
-- with an induction hypothesis for each premise that is itself Sorted.
-- That is the way to prove ins_sorted: ins puts x at its place in a sorted
-- list. Each case is then a job for grind, given ins and the rules:
--
--   grind [ins, Sorted.nil, Sorted.single, Sorted.cons]

inductive Sorted : List Nat → Prop where
  | nil : Sorted []
  | single (x : Nat) : Sorted [x]
  | cons {x y : Nat} {ys : List Nat} : x ≤ y → Sorted (y :: ys) → Sorted (x :: y :: ys)

theorem sorted_123 : Sorted [1, 2, 3] :=
  sorry

theorem not_sorted_21 : ¬ Sorted [2, 1] := by
  sorry

def ins (x : Nat) : List Nat → List Nat
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: ins x ys

theorem ins_sorted (x : Nat) (xs : List Nat) (h : Sorted xs) : Sorted (ins x xs) := by
  sorry
