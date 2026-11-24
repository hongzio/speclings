-- speclings lean 047: classical logic
--
-- So far, every proof built what it claimed: a proof of p ∨ q said which
-- side holds, a proof of ∃ said which value. This is constructive logic.
--
-- Some statements cannot be proved that way, such as p ∨ ¬p for an
-- arbitrary p: there is no way to tell which side holds. Classical logic
-- adds that it holds anyway, as an axiom:
--
--   Classical.em p : p ∨ ¬p              ("excluded middle")
--   by_cases hp : p                      two goals: one with hp : p,
--                                        one with hp : ¬p
--
-- Lean allows it; it is behind Classical.choice, one of the three
-- standard axioms that speclings accepts. In return, statements such as
-- ¬¬p → p become provable.
--
-- In not_and_iff and imp_iff_or, one direction is constructive and the
-- other needs by_cases. Which is which?

theorem excluded_middle (p : Prop) : p ∨ ¬p := sorry

theorem double_neg_elim (p : Prop) : ¬¬p → p := by
  sorry

theorem not_and_iff (p q : Prop) : ¬(p ∧ q) ↔ ¬p ∨ ¬q := by
  sorry

theorem imp_iff_or (p q : Prop) : (p → q) ↔ ¬p ∨ q := by
  sorry
