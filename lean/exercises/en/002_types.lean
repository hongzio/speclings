-- leanlings 002: types
--
-- Every value in Lean has a type, and Lean checks that types fit.
-- #check shows the type of an expression without running it:
--
--   #check 42             42 : Nat
--   #check "Lean"         "Lean" : String
--   #check (-5 : Int)     -5 : Int
--   #check true           Bool.true : Bool
--
-- Nat is the type of natural numbers 0, 1, 2, ... A Nat is never
-- negative. Int, the type of integers, has negative numbers too.
--
-- A def can take arguments. Each one has a name and a type:
--
--   def describe (name : String) (count : Nat) : String := ...
--   describe "Lean" 4      calls it
--
-- Many errors about types read like this:
--
--   failed to synthesize instance of type class
--     Neg Nat
--
-- Lean looked for a way to do something with a type and found none.
-- The last line names what it looked for: Neg Nat is a way to negate a
-- Nat, and HAppend String Nat would be a way to ++ a String and a Nat.
-- These are type classes; they come later. For now, read such an error
-- as "this operation does not exist for these types".
--
-- ++ joins two Strings. To put a number into a String, convert it with
-- toString, or use string interpolation, which converts what is in {}:
--
--   toString 42                      "42"
--   s!"{name} has {count} letters"   "Lean has 4 letters"
--
-- Fix the two definitions below, without changing the #guards. Add a
-- #check of your own to see the type of anything.

def temperature : Nat := -5

#check temperature

#guard temperature + 10 == 5

def describe (name : String) (count : Nat) : String :=
  name ++ " has " ++ count ++ " letters"

#eval describe "Lean" 4

#guard describe "Lean" 4 == "Lean has 4 letters"
#guard describe "Go" 2 == "Go has 2 letters"
