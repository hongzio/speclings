-- speclings lean 030: do
--
-- do runs actions one after the other, one per line:
--
--   def main : IO Unit := do
--     IO.println "one"
--     IO.println "two"
--
-- To use the result of an action, run it with ←, which binds the result
-- to a name (type ← as \l, or write <-):
--
--   let line ← readSomething      -- runs the action; line is its result
--   let action := readSomething   -- does not run it; action is the action
--
-- So in the second line, action has type IO String, not String: it is the
-- recipe, not the meal. An error about a type like ToString (IO Nat) or
-- HAdd (IO Nat) Nat means that an action is used where its result was
-- meant. pure x is the action that does nothing and gives back x.
--
-- roll below is an action that gives a Nat (a dice roll; this die always
-- shows 4). Fix main, so that it prints
--
--   Rolling...
--   You rolled 4, plus one is 5.

def roll : IO Nat := pure 4

def main : IO Unit := do
  IO.println "Rolling..."
  let n := roll
  IO.println s!"You rolled {n}, plus one is {n + 1}."
