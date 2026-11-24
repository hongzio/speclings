-- speclings lean 040: 또는
--
-- p ∨ q (∨ 는 \or 로 입력) 의 증명은 p 의 증명이거나 q 의 증명이고, 어느
-- 쪽인지 말합니다:
--
--   Or.inl hp : p ∨ q        hp : p 로부터 ("왼쪽에")
--   Or.inr hq : p ∨ q        hq : q 로부터
--   left, right              전술 모드에서 증명할 쪽 고르기
--
-- h : p ∨ q 를 쓰려면 match 처럼 두 경우를 모두 다뤄야 합니다:
--
--   cases h with
--   | inl hp => ...          -- p 가 성립하는 경우
--   | inr hq => ...          -- q 가 성립하는 경우
--
-- rcases h with hp | hq 도 같은 일을 하고, 경우마다 하나씩 두 목표를
-- 남깁니다. 그 패턴은 ∧ 의 패턴과 섞을 수 있습니다:
-- rcases h with hp | ⟨hq, hr⟩.

theorem or_swap (p q : Prop) : p ∨ q → q ∨ p := by
  sorry

theorem or_elim (p q r : Prop) (hpr : p → r) (hqr : q → r) : p ∨ q → r := by
  sorry

theorem and_or_distrib (p q r : Prop) : p ∧ (q ∨ r) → (p ∧ q) ∨ (p ∧ r) := by
  sorry
