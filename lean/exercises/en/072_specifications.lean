-- speclings lean 072: writing specifications
--
-- A proof is only as good as its statement. 071 showed a specification
-- that was too weak: "the result is sorted" also holds for badSort. So
-- before proving anything with a specification, test it on examples: it
-- must accept the right answers and reject the wrong ones.
--
-- IsMax xs m should say that m is the largest element of xs. Write it so
-- that the tests below hold. Each wrong answer is one that a weaker
-- specification would let through:
--
--   5 for [3, 1, 2]    at least every element, but not one of them
--   1 for [3, 1, 2]    one of them, but not the largest
--   any m for []       the empty list has no largest element
--
-- Then prove that maxOf, which keeps the largest element so far, meets it.
--
-- IsDedup xs ys should say that ys has the elements of xs, each once, in
-- any order. "No duplicates" alone accepts []; "the same elements" alone
-- accepts xs itself.
--
-- decide proves a test once the definition is unfolded (unfold IsMax;
-- decide), if the definition only uses ∀ x ∈ xs and ∃ x ∈ xs: Lean checks
-- those by going through the list, but it cannot go through every Nat.
-- The library's xs.Nodup says that xs has no duplicates.

def IsMax (xs : List Nat) (m : Nat) : Prop :=
  sorry

theorem max_example : IsMax [3, 1, 2] 3 := by
  sorry

theorem max_not_bound : ¬ IsMax [3, 1, 2] 5 := by
  sorry

theorem max_not_largest : ¬ IsMax [3, 1, 2] 1 := by
  sorry

theorem max_nil (m : Nat) : ¬ IsMax [] m := by
  sorry

def maxOf (x : Nat) : List Nat → Nat
  | [] => x
  | y :: ys => maxOf (max x y) ys

theorem maxOf_isMax (x : Nat) (xs : List Nat) : IsMax (x :: xs) (maxOf x xs) := by
  sorry

def IsDedup (xs ys : List Nat) : Prop :=
  sorry

theorem dedup_example : IsDedup [1, 2, 1, 3] [1, 2, 3] := by
  sorry

theorem dedup_any_order : IsDedup [1, 2, 1, 3] [3, 1, 2] := by
  sorry

theorem dedup_not_empty : ¬ IsDedup [1, 2, 1] [] := by
  sorry

theorem dedup_not_same : ¬ IsDedup [1, 2, 1] [1, 2, 1] := by
  sorry

theorem dedup_not_new : ¬ IsDedup [1, 2] [1, 2, 3] := by
  sorry
