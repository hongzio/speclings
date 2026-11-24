-- leanlings 008: if and let
--
-- if c then a else b is an expression: its value is a when c holds, and b
-- otherwise. Every expression must have a value, so an if needs an else.
--
--   def larger (a b : Nat) : Nat := if a < b then b else a
--
-- The condition c is a Bool, or a Prop that Lean can decide, like a < b.
--
-- let names an intermediate value. The name can be used from the next
-- line on:
--
--   def perimeter (w h : Nat) : Nat :=
--     let half := w + h
--     2 * half
--
-- Fix abs. Then fill in clamp: clamp lo hi x is x, but at least lo and at
-- most hi. (A let or two make it easier to read.)

def abs (x : Int) : Int := if x < 0 then -x

#guard abs (-3) == 3
#guard abs 4 == 4

def clamp (lo hi x : Int) : Int := sorry

#guard clamp 0 10 5 == 5
#guard clamp 0 10 (-5) == 0
#guard clamp 0 10 15 == 10
