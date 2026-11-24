-- leanlings 019: deriving (solution)

structure Point where
  x : Int
  y : Int
  deriving BEq, Repr

def p : Point := ⟨1, 2⟩

#eval p

#guard p == ⟨1, 2⟩
#guard p != ⟨2, 1⟩

def swapXY (p : Point) : Point := ⟨p.y, p.x⟩

#guard swapXY p == ⟨2, 1⟩
