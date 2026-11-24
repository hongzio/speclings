-- speclings lean 039: and
--
-- A proof of p ∧ q (type ∧ as \and) is a pair: a proof of p and a proof
-- of q.
--
--   ⟨hp, hq⟩ : p ∧ q          build one from hp : p and hq : q
--   constructor               in tactic mode: split the goal p ∧ q
--                             into the goals p and q
--   h.1 : p, h.2 : q          the two parts of h : p ∧ q
--   obtain ⟨hp, hq⟩ := h      take h apart into two hypotheses
--
-- Patterns nest: obtain ⟨⟨hp, hq⟩, hr⟩ := h takes apart an
-- h : (p ∧ q) ∧ r, and ⟨hp, hq, hr⟩ is short for ⟨hp, ⟨hq, hr⟩⟩. intro
-- can take a pattern too: intro ⟨hp, hq⟩.
--
-- curry and uncurry show that p ∧ q → r and p → q → r say the same thing,
-- as 009 did for functions of two arguments.

theorem and_swap (p q : Prop) : p ∧ q → q ∧ p := by
  sorry

theorem and_assoc_mp (p q r : Prop) : (p ∧ q) ∧ r → p ∧ (q ∧ r) := by
  sorry

theorem curry (p q r : Prop) : (p ∧ q → r) → (p → q → r) := by
  sorry

theorem uncurry (p q r : Prop) : (p → q → r) → (p ∧ q → r) := by
  sorry
