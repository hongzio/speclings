-- speclings lean 011: pattern matching
--
-- match looks at the shape of a value and takes the first case that fits:
--
--   def describe (n : Nat) : String :=
--     match n with
--     | 0 => "zero"
--     | 1 => "one"
--     | _ => "many"         -- _ fits anything
--
-- A definition can also match its argument right away, without naming it:
--
--   def isZero : Nat → Bool
--     | 0 => true
--     | _ => false
--
-- A pattern can name parts of the value. n + 1 fits every Nat except 0,
-- and names n the number one less:
--
--   def pred : Nat → Nat
--     | 0 => 0
--     | n + 1 => n
--
-- Lean checks that the cases cover every value. If they do not, it lists
-- the missing cases, as patterns. In them, Nat.succ n means n + 1, so
-- Nat.succ (Nat.succ _) is any number of the form _ + 2: 2 or more.
--
-- Fix size: every number from 2 on is "many". Then fill in minusTwo,
-- which subtracts 2 like Nat subtraction does, with a pattern n + 2.

def size : Nat → String
  | 0 => "none"
  | 1 => "one"

#guard size 0 == "none"
#guard size 1 == "one"
#guard size 5 == "many"

def minusTwo : Nat → Nat := sorry

#guard minusTwo 0 == 0
#guard minusTwo 1 == 0
#guard minusTwo 7 == 5
