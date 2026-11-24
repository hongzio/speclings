-- speclings lean 002: 타입
--
-- Lean 의 모든 값에는 타입이 있고, Lean 은 타입이 맞는지 검사합니다.
-- #check 는 식을 실행하지 않고 타입을 보여 줍니다:
--
--   #check 42             42 : Nat
--   #check "Lean"         "Lean" : String
--   #check (-5 : Int)     -5 : Int
--   #check true           Bool.true : Bool
--
-- Nat 은 자연수 0, 1, 2, ... 의 타입입니다. Nat 은 음수가 될 수 없습니다.
-- 정수의 타입 Int 에는 음수도 있습니다.
--
-- def 는 인자를 받을 수 있습니다. 인자마다 이름과 타입이 있습니다:
--
--   def describe (name : String) (count : Nat) : String := ...
--   describe "Lean" 4      호출
--
-- 타입에 관한 에러는 흔히 이렇게 생겼습니다:
--
--   failed to synthesize instance of type class
--     Neg Nat
--
-- Lean 이 어떤 타입으로 무언가를 할 방법을 찾았지만 없었다는 뜻입니다.
-- 마지막 줄이 찾던 것입니다. Neg Nat 은 Nat 의 부호를 바꾸는 방법이고,
-- HAppend String Nat 은 String 과 Nat 을 ++ 하는 방법입니다. 이것들은
-- 타입 클래스이고 나중에 다룹니다. 지금은 "이 타입들에는 이 연산이
-- 없다" 로 읽으면 됩니다.
--
-- ++ 는 String 두 개를 잇습니다. 숫자를 String 에 넣으려면 toString 으로
-- 바꾸거나, {} 안의 값을 바꿔 넣어 주는 문자열 보간을 쓰세요:
--
--   toString 42                      "42"
--   s!"{name} has {count} letters"   "Lean has 4 letters"
--
-- #guard 는 그대로 두고, 아래 두 정의를 고치세요. 무엇이든 타입이
-- 궁금하면 #check 를 직접 더해 보세요.

def temperature : Nat := -5

#check temperature

#guard temperature + 10 == 5

def describe (name : String) (count : Nat) : String :=
  name ++ " has " ++ count ++ " letters"

#eval describe "Lean" 4

#guard describe "Lean" 4 == "Lean has 4 letters"
#guard describe "Go" 2 == "Go has 2 letters"
