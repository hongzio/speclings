-- leanlings 044: exists (solution)

theorem square_49 : ∃ n : Nat, n * n = 49 := ⟨7, rfl⟩

theorem exists_map {α : Type} (P Q : α → Prop) (h : ∀ x, P x → Q x) : (∃ x, P x) → ∃ x, Q x := by
  intro ⟨x, hx⟩
  exact ⟨x, h x hx⟩

theorem not_exists_iff {α : Type} (P : α → Prop) : ¬(∃ x, P x) ↔ ∀ x, ¬P x := by
  constructor
  · intro h x hx
    exact h ⟨x, hx⟩
  · intro h ⟨x, hx⟩
    exact h x hx
