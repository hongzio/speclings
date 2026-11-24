-- leanlings 021: constructors with data (solution)

inductive Shape where
  | square (side : Nat)
  | rect (width height : Nat)
  | triangle (base height : Nat)
  deriving Repr, BEq

def area : Shape → Nat
  | .square s => s * s
  | .rect w h => w * h
  | .triangle b h => b * h / 2

#guard area (.square 3) == 9
#guard area (.rect 2 5) == 10
#guard area (.triangle 4 3) == 6

def scale (k : Nat) : Shape → Shape
  | .square s => .square (k * s)
  | .rect w h => .rect (k * w) (k * h)
  | .triangle b h => .triangle (k * b) (k * h)

#guard scale 2 (.rect 2 5) == .rect 4 10
#guard scale 3 (.square 1) == .square 3

def isSquare : Shape → Bool
  | .square _ => true
  | .rect w h => w == h
  | .triangle _ _ => false

#guard isSquare (.square 3)
#guard isSquare (.rect 2 2)
#guard !isSquare (.rect 2 3)
#guard !isSquare (.triangle 2 2)
