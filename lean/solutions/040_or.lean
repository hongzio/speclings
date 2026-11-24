-- leanlings 040: or (solution)

theorem or_swap (p q : Prop) : p ∨ q → q ∨ p := by
  intro h
  cases h with
  | inl hp => right; exact hp
  | inr hq => left; exact hq

theorem or_elim (p q r : Prop) (hpr : p → r) (hqr : q → r) : p ∨ q → r := by
  intro h
  rcases h with hp | hq
  · exact hpr hp
  · exact hqr hq

theorem and_or_distrib (p q r : Prop) : p ∧ (q ∨ r) → (p ∧ q) ∨ (p ∧ r) := by
  intro ⟨hp, hqr⟩
  rcases hqr with hq | hr
  · exact Or.inl ⟨hp, hq⟩
  · exact Or.inr ⟨hp, hr⟩
