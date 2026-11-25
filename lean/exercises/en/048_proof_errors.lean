-- speclings lean 048: reading proof errors
--
-- Each proof below is almost right, and Lean says what is wrong with it.
-- An error has three parts:
--
--   file:line:column   where: the term or tactic that failed
--   the message        what went wrong
--   the goal           for a tactic, what was known (above ⊢) and what was
--                      left to prove (after ⊢) when it failed
--
-- Five messages you will meet often:
--
--   Application type mismatch     a term has another type than expected:
--                                 often the wrong hypothesis or component
--   Alternative ... has not been provided    cases is missing a case
--   could not unify the conclusion    what apply's theorem proves is not
--                                 the goal
--   unsolved goals                the proof ended with goals left
--   Did not find an occurrence of the pattern    rw: the left side of
--                                 the equation is not in the goal
--
-- Fix each proof; keep the statements. Automatic tactics are still not
-- accepted.

theorem and_swap (p q : Prop) (h : p ∧ q) : q ∧ p :=
  ⟨h.1, h.2⟩

theorem or_swap (p q : Prop) (h : p ∨ q) : q ∨ p := by
  cases h with
  | inl hp => exact Or.inr hp

theorem chain (p q r : Prop) (hpq : p → q) (hqr : q → r) (hp : p) : r := by
  apply hpq
  exact hp

theorem both_parts (p q : Prop) (hp : p) (hq : q) : p ∧ q := by
  constructor
  · exact hp

theorem undo_two (a b : Nat) (h : a + 2 = b) : b - 2 = a := by
  rw [h, Nat.add_sub_cancel]
