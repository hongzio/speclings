-- leanlings 039: and (solution)

theorem and_swap (p q : Prop) : p ∧ q → q ∧ p := by
  intro h
  exact ⟨h.2, h.1⟩

theorem and_assoc_mp (p q r : Prop) : (p ∧ q) ∧ r → p ∧ (q ∧ r) := by
  intro h
  obtain ⟨⟨hp, hq⟩, hr⟩ := h
  exact ⟨hp, hq, hr⟩

theorem curry (p q r : Prop) : (p ∧ q → r) → (p → q → r) := by
  intro h hp hq
  exact h ⟨hp, hq⟩

theorem uncurry (p q r : Prop) : (p → q → r) → (p ∧ q → r) := by
  intro h hpq
  exact h hpq.1 hpq.2
