-- speclings lean 041: not
--
-- False is the statement with no proof. ¬p ("not p", type ¬ as \not) is
-- defined as p → False: a proof of ¬p turns any proof of p into the
-- impossible. So you prove ¬p with intro, like any implication, and use
-- hnp : ¬p by applying it to a proof of p.
--
-- From False, anything follows: there is no case to check.
--
--   exfalso         change the goal to False
--   absurd hp hnp   a proof of anything, from hp : p and hnp : ¬p
--   contradiction   closes the goal when the hypotheses contradict each
--                   other, such as hp : p and hnp : ¬p
--
-- ¬¬p is ¬p → False, so intro works twice on it.

theorem double_neg_intro (p : Prop) : p → ¬¬p := by
  sorry

theorem contrapositive (p q : Prop) : (p → q) → ¬q → ¬p := by
  sorry

theorem not_and_left (p q : Prop) : ¬p → ¬(p ∧ q) := by
  sorry

theorem absurd_example (p q : Prop) : p → ¬p → q := by
  sorry

theorem not_both (p : Prop) : ¬(p ∧ ¬p) := by
  sorry
