-- leanlings 031: let mut and for
--
-- Inside do, you can write code the way you would in an imperative
-- language. let mut declares a variable that can change, and := assigns
-- it a new value. for runs its block once for each element of a list (or
-- an array, or a range [a:b] of Nats):
--
--   let mut count := 0
--   for x in xs do
--     if x > 10 then
--       count := count + 1
--
-- This works even in functions that do no IO: Id.run do ... runs such a
-- block and gives its result. Underneath, Lean turns it into recursion,
-- so nothing actually changes.
--
-- Fix total, the sum of a list. Then fill in countdown: countdown 3 is
-- ["3", "2", "1", "liftoff!"]. main prints it, one element per line.

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
