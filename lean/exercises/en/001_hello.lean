-- leanlings 001: hello
--
-- Welcome to leanlings!
--
-- leanlings is a collection of small, broken Lean files. You learn to
-- read and write Lean by fixing them one at a time. Once you have fixed
-- one, save it and run leanlings again to move on to the next. All
-- explanations are written as comments, like this one.
--
--   -- ...        comment to the end of the line
--   /- ... -/     comment that may span several lines
--
-- A Lean file is a sequence of commands. The most common one is def,
-- which gives a name to a value. It also states the type of the value:
--
--   def name : Type := value
--
-- Lean checks every command. When something is wrong, it reports where
-- (file:line:column) and what:
--
--   work/001_hello.lean:LINE:COLUMN: error: Type mismatch
--
-- One mistake often causes more errors further down. Below, the #eval
-- and the #guard fail too, because answer has an error. (Their messages
-- mention sorry: Lean puts a sorry in place of a definition with an
-- error. You will meet sorry in 003.) So always start with the first
-- error. If your editor runs Lean (lean.nvim, VS Code), it shows the
-- same messages as you type.
--
-- #eval shows the value of an expression, and #guard checks that a
-- condition holds. leanlings tests your solutions with #guard: keep
-- every #guard of an exercise as it is.
--
-- Now look at answer below.

def answer : Nat := "42"

#eval answer

#guard answer == 42
