-- speclings lean 002: types (solution)

def temperature : Int := -5

#check temperature

#guard temperature + 10 == 5

def describe (name : String) (count : Nat) : String :=
  s!"{name} has {count} letters"

#eval describe "Lean" 4

#guard describe "Lean" 4 == "Lean has 4 letters"
#guard describe "Go" 2 == "Go has 2 letters"
