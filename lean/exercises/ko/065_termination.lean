-- speclings lean 065: 종료
--
-- 012 에서 Lean 은 구조적으로 더 작은 인자로 자신을 부르는 함수를
-- 받아들였습니다. 유클리드 알고리즘은 그렇지 않습니다. euclid a b 는
-- euclid b (a % b) 를 부르고, 어느 인자도 이전 인자의 일부가 아닙니다.
-- 그래도 끝납니다. 둘째 인자가 작아지니까요. a % b 는 b 보다 작습니다.
-- 무엇이 작아지는지는 정의 뒤에 termination_by 로 Lean 에게 알려 줍니다:
--
--   termination_by b
--
-- 그러면 Lean 은 매 호출마다 b 가 줄어든다는 것을 증명하려 합니다. 하지
-- 못하면 남은 목표를 보여 주고, decreasing_by 가 그것을 증명합니다:
--
--   decreasing_by exact Nat.mod_lt a (Nat.pos_of_ne_zero h)
--
-- Nat.mod_lt a : b > 0 → a % b < b 이고, Nat.pos_of_ne_zero 는 b ≠ 0 을
-- b > 0 으로 바꿉니다. 그러려면 else 갈래에 b ≠ 0 이라는 사실이 가정으로
-- 있어야 합니다. if h : b = 0 then ... else ... 가 그 이름을 붙입니다.
-- then 갈래에서는 h : b = 0, else 갈래에서는 h : ¬b = 0 입니다.
--
-- Lean 이 측정값을 스스로 찾을 때도 많습니다. 아래 countUp 에서는
-- n - i 가 줄어든다는 것을 알아봅니다.
--
-- euclid 를 고치세요.

def euclid (a b : Nat) : Nat :=
  if b = 0 then a else euclid b (a % b)

#guard euclid 12 18 == 6
#guard euclid 7 0 == 7
#guard euclid 17 5 == 1

def countUp (i n : Nat) : List Nat :=
  if i < n then i :: countUp (i + 1) n else []

#guard countUp 2 5 == [2, 3, 4]
#guard countUp 5 2 == []
