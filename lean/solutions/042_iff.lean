-- speclings lean 042: iff (solution)

theorem and_comm_iff (p q : Prop) : p ∧ q ↔ q ∧ p := by
  constructor
  · intro ⟨hp, hq⟩
    exact ⟨hq, hp⟩
  · intro ⟨hq, hp⟩
    exact ⟨hp, hq⟩

theorem not_or_iff (p q : Prop) : ¬(p ∨ q) ↔ ¬p ∧ ¬q := by
  constructor
  · intro h
    exact ⟨fun hp => h (Or.inl hp), fun hq => h (Or.inr hq)⟩
  · intro ⟨hnp, hnq⟩ h
    rcases h with hp | hq
    · exact hnp hp
    · exact hnq hq

theorem iff_use (p q : Prop) (h : p ↔ q) (hq : q) : p := h.mpr hq
