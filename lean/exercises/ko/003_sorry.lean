-- speclings lean 003: sorry
--
-- sorry 는 아직 쓰지 않은 무언가를 나타냅니다. Lean 은 어떤 값이나 증명
-- 자리에도 sorry 를 받아 주지만, 경고를 냅니다:
--
--   warning: declaration uses `sorry`
--
-- (001 에서 Lean 은 에러가 난 정의 자리에 sorry 를 넣었습니다. 그래서
-- #eval 과 #guard 의 메시지에 sorry 가 나왔던 것입니다.)
--
-- 이제부터 문제에는 여러분이 바꿀 sorry 가 있고, sorry 가 하나도 남지
-- 않으면 통과합니다. 나머지는 주어진 것이니 sorry 만 바꾸세요. #eval 이나
-- 보조 정의처럼 여러분이 쓸 것을 더하는 건 괜찮습니다.
--
-- #guard 와 #eval 은 sorry 가 든 코드를 실행할 수 없습니다. 정의를 채우기
-- 전까지는 Lean 이 그 #guard 들도 에러로 보고합니다.
--
-- triple 은 인자에 3 을 곱하고, greet 는 받은 이름에게 인사해야 합니다.
-- 각각의 #guard 가 말하는 대로요.

def triple (n : Nat) : Nat := sorry

#guard triple 0 == 0
#guard triple 4 == 12

def greet (name : String) : String := sorry

#guard greet "Lean" == "Hello, Lean!"
#guard greet "world" == "Hello, world!"
