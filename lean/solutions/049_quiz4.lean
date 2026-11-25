-- speclings lean 049: quiz 4 (solution)

theorem or_and_distrib (p q r : Prop) : p ∨ (q ∧ r) ↔ (p ∨ q) ∧ (p ∨ r) := by
  constructor
  · intro h
    rcases h with hp | ⟨hq, hr⟩
    · exact ⟨Or.inl hp, Or.inl hp⟩
    · exact ⟨Or.inr hq, Or.inr hr⟩
  · intro ⟨hpq, hpr⟩
    rcases hpq with hp | hq
    · exact Or.inl hp
    · rcases hpr with hp | hr
      · exact Or.inl hp
      · exact Or.inr ⟨hq, hr⟩

theorem exists_forall_swap {α : Type} (P : α → α → Prop) : (∃ x, ∀ y, P x y) → ∀ y, ∃ x, P x y := by
  intro ⟨x, hx⟩ y
  exact ⟨x, hx y⟩

theorem forall_not_exists {α : Type} (P : α → Prop) (h : ∀ x, ¬P x) (x : α) (hx : P x) : False :=
  h x hx

theorem iff_trans' (p q r : Prop) (h1 : p ↔ q) (h2 : q ↔ r) : p ↔ r :=
  ⟨fun hp => h2.mp (h1.mp hp), fun hr => h1.mpr (h2.mpr hr)⟩
