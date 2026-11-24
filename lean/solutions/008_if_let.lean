-- speclings lean 008: if and let (solution)

def abs (x : Int) : Int := if x < 0 then -x else x

#guard abs (-3) == 3
#guard abs 4 == 4

def clamp (lo hi x : Int) : Int :=
  let atLeastLo := if x < lo then lo else x
  if atLeastLo > hi then hi else atLeastLo

#guard clamp 0 10 5 == 5
#guard clamp 0 10 (-5) == 0
#guard clamp 0 10 15 == 10
