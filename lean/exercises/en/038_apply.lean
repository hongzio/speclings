-- speclings lean 038: apply
--
-- exact needs the whole proof at once. apply works backward instead: if
-- the goal is s and you have h3 : r → s, then apply h3 leaves r to prove.
-- A step at a time, from the goal back to what you have.
--
-- With h : p → q → r and the goal r, apply h leaves two goals, p and q.
-- Prove them one after the other, each after a ·.
--
-- assumption closes a goal that is exactly one of the hypotheses, without
-- naming it.
--
-- Prove these with apply, exact and assumption.

theorem chain (p q r s : Prop) (h1 : p → q) (h2 : q → r) (h3 : r → s) (hp : p) : s := by
  sorry

theorem two_premises (p q r : Prop) (h : p → q → r) (hp : p) (hq : q) : r := by
  sorry

theorem pick (p q r : Prop) (hq : q) (h : q → r) (_ : p) : r := by
  sorry
