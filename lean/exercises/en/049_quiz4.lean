-- speclings lean 049: quiz 4
--
-- These use everything from Part 4. Plan each proof before you write it:
-- what does the goal need, and what can each hypothesis give?

theorem or_and_distrib (p q r : Prop) : p ∨ (q ∧ r) ↔ (p ∨ q) ∧ (p ∨ r) := by
  sorry

theorem exists_forall_swap {α : Type} (P : α → α → Prop) : (∃ x, ∀ y, P x y) → ∀ y, ∃ x, P x y := by
  sorry

theorem forall_not_exists {α : Type} (P : α → Prop) (h : ∀ x, ¬P x) (x : α) (hx : P x) : False :=
  sorry

theorem iff_trans' (p q r : Prop) (h1 : p ↔ q) (h2 : q ↔ r) : p ↔ r :=
  sorry
