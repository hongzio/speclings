-- leanlings 033: errors
--
-- Option says "no value". Except ε α says why: its values are .ok x, with
-- x : α, or .error e, with e : ε, often a message String.
--
--   throw e     the error e (in Except, .error e)
--   pure x      the value x (.ok x)
--
-- In a do block, ← stops at the first error and gives it back, so the
-- happy path reads without checks:
--
--   def both (a b : String) : Except String (Nat × Nat) := do
--     let x ← parseAge a     -- an error here ends both with that error
--     let y ← parseAge b
--     return (x, y)
--
-- xs.mapM f applies f to every element, stopping at the first error.
-- s.toNat? reads a Nat from a String: "42".toNat? is some 42.
--
-- (Except has no == of its own. The first line below derives one, so
-- that the #guards can compare results.)
--
-- Fill in parseAge, averageAge and parseAll. parseAge rejects what is not
-- a number, and ages over 150, with the messages the #guards show.

deriving instance BEq for Except

def parseAge (s : String) : Except String Nat := sorry

#guard parseAge "42" == .ok 42
#guard parseAge "x" == .error "not a number: x"
#guard parseAge "200" == .error "too old: 200"

def averageAge (a b : String) : Except String Nat := sorry

#guard averageAge "20" "40" == .ok 30
#guard averageAge "20" "y" == .error "not a number: y"

def parseAll (xs : List String) : Except String (List Nat) := sorry

#guard parseAll ["1", "2"] == .ok [1, 2]
#guard parseAll ["1", "x", "y"] == .error "not a number: x"
