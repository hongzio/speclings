-- speclings lean 007: Bool
--
-- Bool 에는 true 와 false 두 값이 있습니다. 비교는 Bool 을 계산합니다:
--
--   a == b    같음              a != b    다름
--   a < b     작음              a ≤ b     작거나 같음 (\le 로 입력, 또는 <=)
--   x && y    그리고            x || y    또는            !x    아님
--
-- 004 에서 명제의 타입 Prop 을 만났습니다. 2 + 2 = 4 는 증명할 주장인
-- Prop 이고, 2 + 2 == 4 는 계산할 값인 Bool 입니다. Lean 이 계산으로
-- 판정할 수 있는 Prop 은 Bool 이 필요한 자리에서 Bool 로 바뀝니다
-- (decide (3 < 5) 는 true). 그래서 #guard 3 < 5 도 되고, = 와 == 를 둘 다
-- 보게 됩니다.
--
-- isEven 과 isLeapYear 를 채우세요. 4 로 나누어떨어지는 해는 윤년입니다.
-- 단, 100 으로 나누어떨어지는 해는 400 으로도 나누어떨어질 때만
-- 윤년입니다.

def isEven (n : Nat) : Bool := sorry

#guard isEven 0
#guard isEven 10
#guard !isEven 7

def isLeapYear (year : Nat) : Bool := sorry

#guard isLeapYear 2024
#guard !isLeapYear 2023
#guard !isLeapYear 1900
#guard isLeapYear 2000
