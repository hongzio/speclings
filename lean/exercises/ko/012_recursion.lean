-- speclings lean 012: 재귀
--
-- 일반 정의에는 반복문이 없습니다 (do 블록에는 있습니다. Part 3 을
-- 보세요). 함수는 자기 자신을 불러서 반복합니다:
--
--   def factorial : Nat → Nat
--     | 0 => 1
--     | n + 1 => (n + 1) * factorial n
--
-- Lean 은 모든 함수가 끝난다는 것을 알아야 합니다. 그렇지 않으면 논리가
-- 깨집니다. f n = f n + 1 이라는 정의로부터 0 = 1 을 증명할 수 있게
-- 되니까요. factorial 은 매번 더 작은 인자로 (n + 1 대신 n 으로) 자신을
-- 부르므로 받아들여집니다. 이것을 구조적 재귀라고 합니다. 함수가 왜
-- 끝나는지 알 수 없으면 Lean 은 "fail to show termination" 을 보고합니다.
--
-- sumTo 를 고치세요. sumTo n 은 0 + 1 + ... + n 입니다. 그다음 피보나치
-- 수 0, 1, 1, 2, 3, 5, 8, ... 을 계산하는 fib 를 채우세요. 각 수는 앞의
-- 두 수의 합입니다. (factorial 처럼 := sorry 전체를 경우들로 바꾸세요.)

def sumTo : Nat → Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo (n + 1)

#guard sumTo 4 == 10

def fib : Nat → Nat := sorry

#guard fib 0 == 0
#guard fib 1 == 1
#guard fib 10 == 55
