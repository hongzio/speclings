-- speclings lean 026: instances
--
-- Operators are functions from type classes. a + b means HAdd.hAdd a b,
-- and Lean looks for an instance that says how to add two values of these
-- types. For Nat and Int, the instances come with Lean. For your own
-- types, you write them:
--
--   instance : Add Point where
--     add p q := ...
--
-- (Lean gets HAdd Point Point Point from Add Point.) The same goes for
-- other classes: ToString Point says how to turn a Point into a String,
-- which is what s!"{p}" and toString p use.
--
-- Fix shift by adding an instance of Add Point before it, with no change
-- to shift itself. Then fill in the ToString instance: (1, 2) for the
-- point with x = 1 and y = 2.

structure Point where
  x : Int
  y : Int
  deriving BEq, Repr

def shift (p q : Point) : Point := p + q

#guard shift ⟨1, 2⟩ ⟨3, 4⟩ == ⟨4, 6⟩
#guard (⟨1, 2⟩ : Point) + ⟨10, 20⟩ == ⟨11, 22⟩

instance : ToString Point where
  toString p := sorry

#guard s!"{(⟨1, 2⟩ : Point)}" == "(1, 2)"
#guard toString (⟨-1, 0⟩ : Point) == "(-1, 0)"
