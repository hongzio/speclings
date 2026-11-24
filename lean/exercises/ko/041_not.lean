-- leanlings 041: 아님
--
-- False 는 증명이 없는 명제입니다. ¬p ("p 가 아님", ¬ 는 \not 으로 입력) 는
-- p → False 로 정의됩니다. ¬p 의 증명은 p 의 어떤 증명이든 불가능한 것으로
-- 바꿉니다. 그래서 ¬p 는 다른 함의처럼 intro 로 증명하고, hnp : ¬p 는 p 의
-- 증명에 적용해서 씁니다.
--
-- False 로부터는 무엇이든 따라 나옵니다. 확인할 경우가 없으니까요.
--
--   exfalso         목표를 False 로 바꿈
--   absurd hp hnp   hp : p 와 hnp : ¬p 로부터 무엇이든의 증명
--   contradiction   hp : p 와 hnp : ¬p 처럼 가정들이 서로 모순되면 목표를
--                   닫음
--
-- ¬¬p 는 ¬p → False 이므로, intro 가 두 번 됩니다.

theorem double_neg_intro (p : Prop) : p → ¬¬p := by
  sorry

theorem contrapositive (p q : Prop) : (p → q) → ¬q → ¬p := by
  sorry

theorem not_and_left (p q : Prop) : ¬p → ¬(p ∧ q) := by
  sorry

theorem absurd_example (p q : Prop) : p → ¬p → q := by
  sorry

theorem not_both (p : Prop) : ¬(p ∧ ¬p) := by
  sorry
