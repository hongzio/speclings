-- speclings lean 044: exists
--
-- ∃ x, P x ("there is an x with P x", type ∃ as \exists) is proved by
-- giving one such x, the witness, with a proof that it fits:
--
--   ⟨7, h⟩ : ∃ n, P n        when h : P 7
--   exists 7                 in tactic mode: use 7, leaving P 7 to prove
--
-- Using h : ∃ x, P x gives you some x with P x, but not which one:
--
--   obtain ⟨x, hx⟩ := h       x is an unknown value, and hx : P x
--
-- (intro ⟨x, hx⟩ does the same for a goal (∃ x, P x) → ...)

theorem square_49 : ∃ n : Nat, n * n = 49 := sorry

theorem exists_map {α : Type} (P Q : α → Prop) (h : ∀ x, P x → Q x) : (∃ x, P x) → ∃ x, Q x := by
  sorry

theorem not_exists_iff {α : Type} (P : α → Prop) : ¬(∃ x, P x) ↔ ∀ x, ¬P x := by
  sorry
