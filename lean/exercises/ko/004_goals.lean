-- leanlings 004: 목표 (goal)
--
-- Lean 은 증명 보조기이기도 합니다. theorem 은 사실을 말하고 증명합니다:
--
--   theorem 이름 : 명제 := 증명
--
-- 명제는 타입이고, 증명은 그 타입의 값입니다. Lean 은 다른 정의를 검사하는
-- 것과 똑같이 증명을 검사합니다. 명제의 타입은 Prop 입니다
-- (#check 2 + 2 = 4 는 2 + 2 = 4 : Prop 을 보여 줍니다).
--
-- 첫 증명 두 가지:
--
--   rfl      양쪽을 계산한 값이 같은 등식을 증명합니다 ("반사성"):
--            2 + 2 = 4, double 3 = 6
--   decide   Lean 이 계산으로 판정할 수 있는 명제를 증명합니다: 3 < 5
--
-- 증명은 대부분 전술(tactic)로 씁니다. by 다음의 각 줄은 증명할 것을 바꾸는
-- 한 단계이고, 증명할 것을 목표(goal)라고 합니다. Lean 은 목표를 이렇게
-- 씁니다:
--
--   ⊢ 2 + 2 = 4
--
-- 에디터는 커서 위치의 목표를 보여 줍니다 (lean.nvim 과 VS Code 에서는
-- infoview 라고 부릅니다). 터미널에서는 증명이 덜 끝났을 때 Lean 이 남은
-- 목표를 "unsolved goals" 로 보여 줍니다. by 다음의 sorry 하나를 지우고
-- leanlings 를 실행해 보세요.
--
-- 목표 하나를 여러 개로 바꾸는 전술도 있습니다. constructor 는 A ∧ B
-- ("A 그리고 B") 를 두 목표 A 와 B 로 바꾸고, 각각을 · 다음에 차례로
-- 증명합니다 (에디터에서 \. 로 입력하거나, 그냥 . 을 써도 됩니다).
--
-- sorry 를 모두 바꾸세요. rfl 과 decide 는 증명(:= rfl)으로도, 전술
-- (by rfl)로도 쓸 수 있습니다.

def double (n : Nat) : Nat := n + n

theorem two_plus_two : 2 + 2 = 4 := sorry

theorem double_three : double 3 = 6 := by
  sorry

theorem small : 3 < 5 := by
  sorry

theorem both : double 2 = 4 ∧ 4 < double 3 := by
  constructor
  · sorry
  · sorry
