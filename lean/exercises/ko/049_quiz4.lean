-- speclings lean 049: 퀴즈 4
--
-- Part 4 의 내용을 모두 씁니다. 쓰기 전에 증명마다 계획을 세워 보세요.
-- 목표에는 무엇이 필요하고, 각 가정은 무엇을 줄 수 있나요?

theorem or_and_distrib (p q r : Prop) : p ∨ (q ∧ r) ↔ (p ∨ q) ∧ (p ∨ r) := by
  sorry

theorem exists_forall_swap {α : Type} (P : α → α → Prop) : (∃ x, ∀ y, P x y) → ∀ y, ∃ x, P x y := by
  sorry

theorem forall_not_exists {α : Type} (P : α → Prop) (h : ∀ x, ¬P x) (x : α) (hx : P x) : False :=
  sorry

theorem iff_trans' (p q r : Prop) (h1 : p ↔ q) (h2 : q ↔ r) : p ↔ r :=
  sorry
