-- speclings lean 044: 존재
--
-- ∃ x, P x ("P x 인 x 가 있다", ∃ 는 \exists 로 입력) 는 그런 x 하나, 곧
-- 증인(witness)을 그것이 맞다는 증명과 함께 주어서 증명합니다:
--
--   ⟨7, h⟩ : ∃ n, P n        h : P 7 일 때
--   exists 7                 전술 모드에서 7 을 쓰고, P 7 을 증명할 것으로
--                            남김
--
-- h : ∃ x, P x 를 쓰면 P x 인 어떤 x 를 얻지만, 그것이 무엇인지는 모릅니다:
--
--   obtain ⟨x, hx⟩ := h       x 는 알 수 없는 값이고, hx : P x
--
-- (목표가 (∃ x, P x) → ... 이면 intro ⟨x, hx⟩ 가 같은 일을 합니다.)

theorem square_49 : ∃ n : Nat, n * n = 49 := sorry

theorem exists_map {α : Type} (P Q : α → Prop) (h : ∀ x, P x → Q x) : (∃ x, P x) → ∃ x, Q x := by
  sorry

theorem not_exists_iff {α : Type} (P : α → Prop) : ¬(∃ x, P x) ↔ ∀ x, ¬P x := by
  sorry
