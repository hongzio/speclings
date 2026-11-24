-- leanlings 006: integers (solution)

#guard (-7 : Int) / 2 == -4
#guard (-7 : Int) % 2 == 1
#guard Int.toNat (-3) == 0
#guard Int.natAbs (-3) == 3

def change (paid price : Nat) : Int :=
  let diff : Int := paid - price
  diff

#guard change 5 3 == 2
#guard change 3 5 == -2
