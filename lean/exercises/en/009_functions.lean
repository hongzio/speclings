-- leanlings 009: functions
--
-- Arguments are written after the function, separated by spaces, with no
-- parentheses or commas: area 3 4. (area (3, 4) would pass one argument,
-- a pair.)
--
-- A function of two Nats returning a Nat has the type Nat → Nat → Nat
-- (type → as \to, or write ->). The arrow groups to the right:
--
--   Nat → Nat → Nat    means    Nat → (Nat → Nat)
--
-- So a function of two arguments is a function that takes the first
-- argument and returns a function of the second. Giving it only the
-- first is fine, and gives that function:
--
--   #check area 3        area 3 : Nat → Nat
--   #eval area 3 4       12, that is (area 3) 4
--
-- This is partial application. When an error says that something has a
-- type like Nat → Nat where a Nat was expected, an argument is missing.
--
-- Fix square. Then fill in areaWithWidth2 by applying area to one argument.

def area (width height : Nat) : Nat := width * height

#check area

def square (side : Nat) : Nat := area side

#guard square 3 == 9

def areaWithWidth2 : Nat → Nat := sorry

#guard areaWithWidth2 5 == 10
