-- leanlings 018: structures (solution)

structure Point where
  x : Int
  y : Int

def origin : Point := { x := 0, y := 0 }

#guard origin.x == 0 && origin.y == 0

def moveRight (p : Point) (dx : Int) : Point := { p with x := p.x + dx }

#guard (moveRight ⟨1, 2⟩ 3).x == 4
#guard (moveRight ⟨1, 2⟩ 3).y == 2

def add (p q : Point) : Point := ⟨p.x + q.x, p.y + q.y⟩

#guard (add ⟨1, 2⟩ ⟨3, 4⟩).x == 4
#guard (add ⟨1, 2⟩ ⟨3, 4⟩).y == 6
