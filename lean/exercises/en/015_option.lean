-- leanlings 015: Option
--
-- What is the first element of an empty list? There is none. Some
-- functions have no answer for some inputs, and Lean makes you say what
-- happens then. Look at the type of List.head:
--
--   List.head : (xs : List α) → xs ≠ [] → α
--
-- Besides the list, it takes a proof that the list is not empty (Part 6
-- is about such functions). xs.head without that proof is a function
-- still waiting for it, which is what the error below says.
--
-- The other way is to return an Option α: either none, or some x for a
-- value x : α.
--
--   [5, 6].head?     some 5
--   [].head?         none
--
-- match takes an Option apart,
--
--   match xs.head? with
--   | none => 0
--   | some x => x
--
-- and o.getD d is the value in o, or d if o is none.
--
-- Fix first. Then fill in firstOr, and safeDiv, which is none when
-- dividing by 0 (instead of Lean's a / 0 = 0).

def first (xs : List Nat) : Option Nat := xs.head

#guard first [] == none
#guard first [7, 8] == some 7

def firstOr (xs : List Nat) (fallback : Nat) : Nat := sorry

#guard firstOr [7, 8] 0 == 7
#guard firstOr [] 42 == 42

def safeDiv (a b : Nat) : Option Nat := sorry

#guard safeDiv 7 2 == some 3
#guard safeDiv 7 0 == none
