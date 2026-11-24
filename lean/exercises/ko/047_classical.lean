-- speclings lean 047: 고전 논리
--
-- 지금까지 모든 증명은 주장한 것을 만들어 냈습니다. p ∨ q 의 증명은 어느
-- 쪽이 성립하는지 말했고, ∃ 의 증명은 어떤 값인지 말했습니다. 이것이
-- 구성적(constructive) 논리입니다.
--
-- 어떤 명제는 그렇게 증명할 수 없습니다. 임의의 p 에 대한 p ∨ ¬p 가
-- 그렇습니다. 어느 쪽이 성립하는지 알 방법이 없으니까요. 고전 논리는
-- 그래도 성립한다는 것을 공리로 더합니다:
--
--   Classical.em p : p ∨ ¬p              ("배중률")
--   by_cases hp : p                      두 목표: hp : p 인 것과
--                                        hp : ¬p 인 것
--
-- Lean 은 이것을 허용합니다. speclings 가 받아들이는 세 표준 공리 중
-- 하나인 Classical.choice 가 그 바탕입니다. 그 대가로 ¬¬p → p 같은
-- 명제를 증명할 수 있게 됩니다.
--
-- not_and_iff 와 imp_iff_or 에서 한 방향은 구성적이고, 다른 방향은
-- by_cases 가 필요합니다. 어느 쪽이 어느 쪽일까요?

theorem excluded_middle (p : Prop) : p ∨ ¬p := sorry

theorem double_neg_elim (p : Prop) : ¬¬p → p := by
  sorry

theorem not_and_iff (p q : Prop) : ¬(p ∧ q) ↔ ¬p ∨ ¬q := by
  sorry

theorem imp_iff_or (p q : Prop) : (p → q) ↔ ¬p ∨ q := by
  sorry
