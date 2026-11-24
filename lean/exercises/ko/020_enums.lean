-- leanlings 020: 열거형
--
-- inductive 는 그 타입의 값을 만드는 모든 방법, 곧 생성자들을 나열해서
-- 새 타입을 정의합니다. 아무것도 받지 않는 생성자들이라면 그냥 값의
-- 목록입니다:
--
--   inductive Weekday where
--     | monday
--     | tuesday
--     ...
--
-- 값은 Weekday.monday, Weekday.tuesday, ... 입니다. Lean 이 기대하는
-- 타입을 알 때는 .monday 로 충분합니다. match 로 값을 구별하고, 한
-- 경우가 여러 값을 덮을 수도 있습니다: | .saturday | .sunday => ...
--
-- isWeekend 와, 다음 요일을 주는 next 를 채우세요.

inductive Weekday where
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  | sunday
  deriving Repr, BEq

def isWeekend : Weekday → Bool := sorry

#guard isWeekend .saturday
#guard isWeekend .sunday
#guard !isWeekend .monday

def next : Weekday → Weekday := sorry

#guard next .monday == .tuesday
#guard next .sunday == .monday
