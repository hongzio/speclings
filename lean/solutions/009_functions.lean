-- speclings lean 009: functions (solution)

def area (width height : Nat) : Nat := width * height

#check area

def square (side : Nat) : Nat := area side side

#guard square 3 == 9

def areaWithWidth2 : Nat → Nat := area 2

#guard areaWithWidth2 5 == 10
