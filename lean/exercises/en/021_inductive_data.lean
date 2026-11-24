-- speclings lean 021: constructors with data
--
-- Constructors can carry data. A Shape below is a square with a side, a
-- rectangle with a width and a height, or a triangle with a base and a
-- height:
--
--   .square 3        .rect 2 5        .triangle 4 3
--
-- A match on a Shape has one case per constructor, and each case names
-- the data it carries:
--
--   | .rect w h => ...
--
-- (A structure is an inductive type with a single constructor. Shape has
-- three, so a Shape is exactly one of them.)
--
-- Fill in area (a triangle has half of base * height), scale, which
-- multiplies every length by k, and isSquare: a rectangle with equal
-- sides is a square too.

inductive Shape where
  | square (side : Nat)
  | rect (width height : Nat)
  | triangle (base height : Nat)
  deriving Repr, BEq

def area : Shape → Nat := sorry

#guard area (.square 3) == 9
#guard area (.rect 2 5) == 10
#guard area (.triangle 4 3) == 6

def scale (k : Nat) : Shape → Shape := sorry

#guard scale 2 (.rect 2 5) == .rect 4 10
#guard scale 3 (.square 1) == .square 3

def isSquare : Shape → Bool := sorry

#guard isSquare (.square 3)
#guard isSquare (.rect 2 2)
#guard !isSquare (.rect 2 3)
#guard !isSquare (.triangle 2 2)
