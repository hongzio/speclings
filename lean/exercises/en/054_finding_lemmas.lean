-- speclings lean 054: finding lemmas
--
-- So far, you proved facts about functions defined in the exercise. For
-- the library's own functions, such as List.length, List.reverse and the
-- arithmetic of Nat, thousands of facts are already proved. You will
-- rarely know their names, but Lean can search for them:
--
--   exact?     looks for a theorem that proves the goal, and suggests it:
--              Try this: exact List.length_append
--   apply?     the same, also with theorems that leave goals to prove
--   rw?        lists the rewrites that apply to the goal: many, so pick
--              the one that gets you closer
--   #check     shows the statement of a name: #check @List.length_reverse
--
-- Names follow a pattern: the function, then what the theorem says about
-- it. List.length_append is about the length of an append, and
-- List.reverse_reverse about reversing twice. Guess a name, then #check it.
--
-- Search tactics do not stay in your file: replace each with what it
-- suggests. When speclings rejects one, it shows the suggestions
-- (Try this: ...) in the order of the proofs, and your editor shows each
-- at its proof. simp, omega and the other automatic tactics are still not
-- accepted.

theorem len_append (xs ys : List Nat) : (xs ++ ys).length = xs.length + ys.length := by
  sorry

theorem rev_rev (xs : List Nat) : xs.reverse.reverse = xs := by
  sorry

theorem len_map (f : Nat → Nat) (xs : List Nat) : (xs.map f).length = xs.length := by
  sorry

theorem lt_le (a b : Nat) (h : a < b) : a ≤ b := by
  sorry

theorem sub_then_add (a b : Nat) (h : b ≤ a) : a - b + b = a := by
  sorry

theorem len_rev_append (xs ys : List Nat) : (xs ++ ys).reverse.length = ys.length + xs.length := by
  sorry
