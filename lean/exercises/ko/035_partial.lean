-- leanlings 035: 부분 함수
--
-- n 의 콜라츠 단계: n 이 짝수면 반으로 나누고, 아니면 3n + 1 을 취해서,
-- 1 이 될 때까지의 단계를 셉니다. 6 에서 시작하면:
--
--   6, 3, 10, 5, 16, 8, 4, 2, 1       8 단계
--
-- 모든 n 에 대해 1 에 도달할까요? 아무도 모릅니다. 유명한 미해결
-- 문제입니다. 그래서 아래 collatz 가 끝난다는 것을 Lean 에게 보일 수 없고,
-- Lean 은 이것을 거부합니다 (왜 그래야 하는지는 012 에서 설명했습니다).
--
-- partial def 는 종료 증명 없이 함수를 받아들이고, Lean 은 그 함수를
-- 컴파일하고 실행할 수 있습니다. 대가가 있습니다. Lean 은 부분 함수가
-- 무엇을 계산하는지 전혀 모르므로, 그 함수에 관한 정리는 하나도 증명할
-- 수 없습니다. (반환 타입에는 Nat 의 0 처럼 값이 있어야 하고, Lean 은
-- 그것을 대역으로 씁니다.)
--
-- collatz 를 고치세요. 그다음 longestBelow n 을 채우세요. n 보다 작은 수
-- 중 단계가 가장 많은 수이고, 같으면 가장 작은 수입니다.

def collatz (n : Nat) : Nat :=
  if n ≤ 1 then 0 else 1 + collatz (if n % 2 == 0 then n / 2 else 3 * n + 1)

#guard collatz 1 == 0
#guard collatz 6 == 8
#guard collatz 27 == 111

def longestBelow (n : Nat) : Nat := sorry

#guard longestBelow 10 == 9
#guard longestBelow 30 == 27
