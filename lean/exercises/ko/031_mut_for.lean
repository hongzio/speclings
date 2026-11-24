-- leanlings 031: let mut 와 for
--
-- do 안에서는 명령형 언어처럼 코드를 쓸 수 있습니다. let mut 은 바뀔 수
-- 있는 변수를 선언하고, := 로 새 값을 대입합니다. for 는 리스트 (또는
-- 배열, 또는 Nat 의 범위 [a:b]) 의 원소마다 블록을 한 번씩 실행합니다:
--
--   let mut count := 0
--   for x in xs do
--     if x > 10 then
--       count := count + 1
--
-- IO 를 하지 않는 함수에서도 됩니다. Id.run do ... 가 그런 블록을 실행해
-- 결과를 줍니다. 속에서는 Lean 이 이것을 재귀로 바꾸므로, 실제로 바뀌는
-- 것은 없습니다.
--
-- 리스트의 합인 total 을 고치세요. 그다음 countdown 을 채우세요.
-- countdown 3 은 ["3", "2", "1", "liftoff!"] 입니다. main 이 그것을 한 줄에
-- 하나씩 출력합니다.

def total (xs : List Nat) : Nat := Id.run do
  let sum := 0
  for x in xs do
    sum := sum + x
  return sum

#guard total [1, 2, 3] == 6
#guard total [] == 0

def countdown (n : Nat) : List String := sorry

#guard countdown 3 == ["3", "2", "1", "liftoff!"]
#guard countdown 0 == ["liftoff!"]

def main : IO Unit := do
  for line in countdown 3 do
    IO.println line
