-- leanlings 019: deriving
--
-- In 018, the #guards compared points field by field. Comparing two
-- Points with == needs a way to compare Points: an instance of BEq Point.
-- Lean does not make one up by itself, but it writes one for you when
-- you ask, with deriving after the fields:
--
--   structure Point where
--     x : Int
--     y : Int
--     deriving BEq, Repr
--
-- The derived == compares the fields one by one. Repr is how #eval shows
-- a value. (#eval shows structures even without it, but other commands
-- need it.)
--
-- Read the error: its Hint also suggests a way to fix it. Then fill in
-- swapXY, which swaps the coordinates of a point.

structure Point where
  x : Int
  y : Int

def p : Point := ⟨1, 2⟩

#eval p

#guard p == ⟨1, 2⟩
#guard p != ⟨2, 1⟩

def swapXY (p : Point) : Point := sorry

#guard swapXY p == ⟨2, 1⟩
