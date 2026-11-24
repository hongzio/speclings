-- speclings lean 029: main
--
-- 지금까지 Lean 은 값을 계산했습니다. 프로그램은 무언가를 하기도 합니다.
-- 출력하고, 파일을 읽고, 네트워크와 통신합니다. Lean 에서는 이렇게 할
-- 일도 값, 곧 동작(action)이고, 타입은 IO α 입니다. 동작을 실행하면 무언가를
-- 하고 α 타입의 결과를 줍니다. IO.println "hi" 의 타입은 IO Unit 입니다.
-- 출력을 하고, 별 의미 없는 값을 돌려줍니다 (Unit 의 값은 () 하나뿐).
--
-- 프로그램은 main 이라는 이름의 IO Unit 타입 동작입니다. 이렇게
-- 실행하거나,
--
--   lean --run work/029_main.lean
--
-- 파일에 #eval main 을 쓰면 됩니다. 이제부터 어떤 문제는 main 이 출력하는
-- 것을 검사합니다. speclings 가 main 을 실행해 출력을 비교합니다.
--
-- 아래 main 은 타입이 틀렸습니다. 프로그램이 Hello, speclings! 를
-- 출력하도록 고치세요.

def greeting : String := "Hello, speclings!"

def main : Unit := IO.println greeting
