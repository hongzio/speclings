-- speclings lean 036: quiz 3
--
-- Write a program that counts the words of text and prints each word with
-- its count, in the order the words first appear:
--
--   the: 3
--   cat: 1
--   sat: 1
--   on: 1
--   mat: 1
--   end: 1
--
-- countWords does the counting, on a list of words. One way: go through
-- the words with foldl, keeping a list of (word, count) pairs. If the
-- word is already there, add 1 to its count; otherwise add (word, 1) at
-- the end. main then prints the result.

def text : String := "the cat sat on the mat the end"

def countWords (words : List String) : List (String × Nat) := sorry

#guard countWords ["a", "b", "a"] == [("a", 2), ("b", 1)]
#guard countWords [] == []

def main : IO Unit := sorry
