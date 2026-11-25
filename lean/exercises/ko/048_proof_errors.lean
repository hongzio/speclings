-- speclings lean 048: 증명 에러 읽기
--
-- 아래 증명들은 거의 맞았고, Lean 이 무엇이 틀렸는지 말해 줍니다.
-- 에러는 세 부분으로 되어 있습니다:
--
--   파일:줄:열     어디서: 실패한 항이나 전술
--   메시지         무엇이 잘못됐는지
--   목표           전술이라면, 실패한 때에 알던 것(⊢ 위)과 남은 증명할
--                  것(⊢ 뒤)
--
-- 자주 만날 다섯 메시지:
--
--   Application type mismatch     항의 타입이 기대와 다름: 가정이나
--                                 성분을 잘못 고른 경우가 많음
--   Alternative ... has not been provided    cases 에 빠진 경우가 있음
--   could not unify the conclusion    apply 한 정리가 증명하는 것이 목표와
--                                 다름
--   unsolved goals                목표가 남은 채로 증명이 끝남
--   Did not find an occurrence of the pattern    rw: 등식의 왼쪽이
--                                 목표에 없음
--
-- 명제는 그대로 두고 증명을 고치세요. 자동 전술은 아직 받아들이지
-- 않습니다.

theorem and_swap (p q : Prop) (h : p ∧ q) : q ∧ p :=
  ⟨h.1, h.2⟩

theorem or_swap (p q : Prop) (h : p ∨ q) : q ∨ p := by
  cases h with
  | inl hp => exact Or.inr hp

theorem chain (p q r : Prop) (hpq : p → q) (hqr : q → r) (hp : p) : r := by
  apply hpq
  exact hp

theorem both_parts (p q : Prop) (hp : p) (hq : q) : p ∧ q := by
  constructor
  · exact hp

theorem undo_two (a b : Nat) (h : a + 2 = b) : b - 2 = a := by
  rw [h, Nat.add_sub_cancel]
