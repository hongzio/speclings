-- leanlings 015: Option (solution)

def first (xs : List Nat) : Option Nat := xs.head?

#guard first [] == none
#guard first [7, 8] == some 7

def firstOr (xs : List Nat) (fallback : Nat) : Nat := (first xs).getD fallback

#guard firstOr [7, 8] 0 == 7
#guard firstOr [] 42 == 42

def safeDiv (a b : Nat) : Option Nat := if b == 0 then none else some (a / b)

#guard safeDiv 7 2 == some 3
#guard safeDiv 7 0 == none
