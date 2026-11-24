-- speclings lean 039: 그리고
--
-- p ∧ q (∧ 는 \and 로 입력) 의 증명은 쌍입니다. p 의 증명과 q 의 증명.
--
--   ⟨hp, hq⟩ : p ∧ q          hp : p 와 hq : q 로 만들기
--   constructor               전술 모드에서 목표 p ∧ q 를 목표 p 와 q 로
--                             나누기
--   h.1 : p, h.2 : q          h : p ∧ q 의 두 부분
--   obtain ⟨hp, hq⟩ := h      h 를 두 가정으로 풀기
--
-- 패턴은 중첩됩니다. obtain ⟨⟨hp, hq⟩, hr⟩ := h 는 h : (p ∧ q) ∧ r 을
-- 풀고, ⟨hp, hq, hr⟩ 은 ⟨hp, ⟨hq, hr⟩⟩ 를 줄여 쓴 것입니다. intro 도 패턴을
-- 받을 수 있습니다: intro ⟨hp, hq⟩.
--
-- curry 와 uncurry 는, 009 에서 인자가 둘인 함수에 대해 본 것처럼,
-- p ∧ q → r 과 p → q → r 이 같은 말이라는 것을 보여 줍니다.

theorem and_swap (p q : Prop) : p ∧ q → q ∧ p := by
  sorry

theorem and_assoc_mp (p q r : Prop) : (p ∧ q) ∧ r → p ∧ (q ∧ r) := by
  sorry

theorem curry (p q r : Prop) : (p ∧ q → r) → (p → q → r) := by
  sorry

theorem uncurry (p q r : Prop) : (p → q → r) → (p ∧ q → r) := by
  sorry
