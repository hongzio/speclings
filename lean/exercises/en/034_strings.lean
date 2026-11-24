-- leanlings 034: strings
--
-- Some functions on Strings and Chars:
--
--   "a b".splitOn " "          ["a", "b"]; two spaces in a row give an
--                              empty String between them
--   "42".toNat?                some 42 ("x".toNat? is none)
--   "abc".toList               ['a', 'b', 'c'], a List Char
--   String.ofList ['a', 'b']   "ab"
--   'a'.isDigit                false ('7'.isDigit is true)
--   "lean".capitalize          "Lean"
--   ", ".intercalate ["a", "b"]    "a, b"
--   "abc".length               3
--
-- (A Char is written in single quotes.) xs.filterMap f applies f, which
-- gives an Option, to every element, and keeps the values of the somes.
--
-- Fill in wordCount (words are separated by spaces, maybe several),
-- sumNumbers (the sum of the words that are numbers), onlyDigits and
-- titleCase.

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
