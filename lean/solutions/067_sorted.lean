-- leanlings 067: a specification (solution)

inductive Sorted : List Nat → Prop where
  | nil : Sorted []
  | single (x : Nat) : Sorted [x]
  | cons {x y : Nat} {ys : List Nat} : x ≤ y → Sorted (y :: ys) → Sorted (x :: y :: ys)

theorem sorted_123 : Sorted [1, 2, 3] :=
  .cons (by decide) (.cons (by decide) (.single 3))

theorem not_sorted_21 : ¬ Sorted [2, 1] := by
  intro h
  cases h with
  | cons h12 _ => omega

def ins (x : Nat) : List Nat → List Nat
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: ins x ys

theorem ins_sorted (x : Nat) (xs : List Nat) (h : Sorted xs) : Sorted (ins x xs) := by
  induction h <;> grind [ins, Sorted.nil, Sorted.single, Sorted.cons]
