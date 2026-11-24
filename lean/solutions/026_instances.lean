-- leanlings 026: instances (solution)

structure Point where
  x : Int
  y : Int
  deriving BEq, Repr

instance : Add Point where
  add p q := ⟨p.x + q.x, p.y + q.y⟩

def shift (p q : Point) : Point := p + q

#guard shift ⟨1, 2⟩ ⟨3, 4⟩ == ⟨4, 6⟩
#guard (⟨1, 2⟩ : Point) + ⟨10, 20⟩ == ⟨11, 22⟩

instance : ToString Point where
  toString p := s!"({p.x}, {p.y})"

#guard s!"{(⟨1, 2⟩ : Point)}" == "(1, 2)"
#guard toString (⟨-1, 0⟩ : Point) == "(-1, 0)"
