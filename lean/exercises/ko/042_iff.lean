-- leanlings 042: 필요충분조건
--
-- p ↔ q ("p 일 때 그리고 그때만 q", ↔ 는 \iff 로 입력) 는 p 와 q 가 서로를
-- 함의할 때 성립합니다. 그 증명은 함의 한 쌍입니다:
--
--   ⟨fun hp => ..., fun hq => ...⟩ : p ↔ q
--   constructor          목표 p ↔ q 를 p → q 와 q → p 로 나눔
--   h.mp : p → q         h : p ↔ q 의 두 방향
--   h.mpr : q → p        ("modus ponens" 와 "reverse")
--
-- not_or_iff 는 드모르간 법칙 중 하나입니다.

theorem and_comm_iff (p q : Prop) : p ∧ q ↔ q ∧ p := by
  sorry

theorem not_or_iff (p q : Prop) : ¬(p ∨ q) ↔ ¬p ∧ ¬q := by
  sorry

theorem iff_use (p q : Prop) (h : p ↔ q) (hq : q) : p := sorry
