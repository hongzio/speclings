-- leanlings 040: or
--
-- A proof of p ∨ q (type ∨ as \or) is a proof of p or a proof of q, and
-- says which:
--
--   Or.inl hp : p ∨ q        from hp : p ("in left")
--   Or.inr hq : p ∨ q        from hq : q
--   left, right              in tactic mode: choose the side to prove
--
-- Using h : p ∨ q means handling both cases, like a match:
--
--   cases h with
--   | inl hp => ...          -- the case where p holds
--   | inr hq => ...          -- the case where q holds
--
-- rcases h with hp | hq does the same and leaves two goals, one for each
-- case. Its patterns combine with those of ∧: rcases h with hp | ⟨hq, hr⟩.

theorem or_swap (p q : Prop) : p ∨ q → q ∨ p := by
  sorry

theorem or_elim (p q r : Prop) (hpr : p → r) (hqr : q → r) : p ∨ q → r := by
  sorry

theorem and_or_distrib (p q r : Prop) : p ∧ (q ∨ r) → (p ∧ q) ∨ (p ∧ r) := by
  sorry
