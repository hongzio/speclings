-- leanlings 034: 문자열
--
-- String 과 Char 에 대한 함수 몇 가지:
--
--   "a b".splitOn " "          ["a", "b"]. 공백이 두 개 연달아 있으면
--                              그 사이에 빈 String 이 생김
--   "42".toNat?                some 42 ("x".toNat? 는 none)
--   "abc".toList               ['a', 'b', 'c'], List Char
--   String.ofList ['a', 'b']   "ab"
--   'a'.isDigit                false ('7'.isDigit 은 true)
--   "lean".capitalize          "Lean"
--   ", ".intercalate ["a", "b"]    "a, b"
--   "abc".length               3
--
-- (Char 는 작은따옴표로 씁니다.) xs.filterMap f 는 Option 을 주는 f 를 모든
-- 원소에 적용하고, some 인 값들만 남깁니다.
--
-- wordCount (단어는 공백으로 나뉨, 공백이 여러 개일 수도 있음),
-- sumNumbers (수인 단어들의 합), onlyDigits, titleCase 를 채우세요.

def wordCount (s : String) : Nat := sorry

#guard wordCount "the quick brown fox" == 4
#guard wordCount "  spaced   out  " == 2
#guard wordCount "" == 0

def sumNumbers (s : String) : Nat := sorry

#guard sumNumbers "1 apple 2 pears 10" == 13

def onlyDigits (s : String) : String := sorry

#guard onlyDigits "a1b2c3" == "123"

def titleCase (s : String) : String := sorry

#guard titleCase "hello lean world" == "Hello Lean World"
