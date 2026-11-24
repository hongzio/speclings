-- speclings lean 018: structures
--
-- A structure groups named values, its fields, into one value:
--
--   structure Point where
--     x : Int
--     y : Int
--
-- There are three ways to build a Point. All give the same value:
--
--   { x := 1, y := 2 }     every field by name
--   ⟨1, 2⟩                 the fields in order (type ⟨ ⟩ as \< and \>)
--   Point.mk 1 2           the constructor, a function Lean defines for you
--
-- p.x is the field x of p. Values never change in Lean, but { p with
-- x := 5 } is a new Point, a copy of p with another x.
--
-- Fix origin, the point (0, 0). Then fill in moveRight, which moves a
-- point dx to the right, and add, which adds two points field by field.

structure Point where
  x : Int
  y : Int

def origin : Point := { x := 0 }

#guard origin.x == 0 && origin.y == 0

def moveRight (p : Point) (dx : Int) : Point := sorry

#guard (moveRight ⟨1, 2⟩ 3).x == 4
#guard (moveRight ⟨1, 2⟩ 3).y == 2

def add (p q : Point) : Point := sorry

#guard (add ⟨1, 2⟩ ⟨3, 4⟩).x == 4
#guard (add ⟨1, 2⟩ ⟨3, 4⟩).y == 6
