-- speclings lean 030: do
--
-- do 는 동작들을 한 줄에 하나씩, 차례로 실행합니다:
--
--   def main : IO Unit := do
--     IO.println "one"
--     IO.println "two"
--
-- 동작의 결과를 쓰려면 ← 로 실행해서 결과에 이름을 붙이세요 (← 는 \l 로
-- 입력하거나 <- 로 씁니다):
--
--   let line ← readSomething      -- 동작을 실행하고, line 은 그 결과
--   let action := readSomething   -- 실행하지 않고, action 은 동작 자체
--
-- 그러니 둘째 줄의 action 은 String 이 아니라 IO String 타입입니다.
-- 요리가 아니라 요리법입니다. ToString (IO Nat) 이나 HAdd (IO Nat) Nat 같은
-- 타입에 관한 에러는, 결과를 써야 할 자리에 동작을 썼다는 뜻입니다.
-- pure x 는 아무것도 하지 않고 x 를 돌려주는 동작입니다.
--
-- 아래 roll 은 Nat 을 주는 동작입니다 (주사위 굴리기. 이 주사위는 늘 4 가
-- 나옵니다). main 이 다음을 출력하도록 고치세요:
--
--   Rolling...
--   You rolled 4, plus one is 5.

def roll : IO Nat := pure 4

def main : IO Unit := do
  IO.println "Rolling..."
  let n := roll
  IO.println s!"You rolled {n}, plus one is {n + 1}."
