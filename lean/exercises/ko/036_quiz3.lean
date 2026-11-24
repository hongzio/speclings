-- leanlings 036: 퀴즈 3
--
-- text 의 단어 수를 세고, 단어가 처음 나온 순서대로 각 단어와 그 개수를
-- 출력하는 프로그램을 쓰세요:
--
--   the: 3
--   cat: 1
--   sat: 1
--   on: 1
--   mat: 1
--   end: 1
--
-- 세는 일은 단어 리스트를 받는 countWords 가 합니다. 한 가지 방법:
-- (단어, 개수) 쌍의 리스트를 들고 foldl 로 단어들을 훑습니다. 단어가 이미
-- 있으면 그 개수에 1 을 더하고, 없으면 끝에 (단어, 1) 을 더합니다. 그다음
-- main 이 결과를 출력합니다.

def text : String := "the cat sat on the mat the end"

def countWords (words : List String) : List (String × Nat) := sorry

#guard countWords ["a", "b", "a"] == [("a", 2), ("b", 1)]
#guard countWords [] == []

def main : IO Unit := sorry
