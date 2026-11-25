-- speclings lean 065: termination (solution)

def euclid (a b : Nat) : Nat :=
  if h : b = 0 then a else euclid b (a % b)
termination_by b
decreasing_by exact Nat.mod_lt a (Nat.pos_of_ne_zero h)

#guard euclid 12 18 == 6
#guard euclid 7 0 == 7
#guard euclid 17 5 == 1

def countUp (i n : Nat) : List Nat :=
  if i < n then i :: countUp (i + 1) n else []

#guard countUp 2 5 == [2, 3, 4]
#guard countUp 5 2 == []
