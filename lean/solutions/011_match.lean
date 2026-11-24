-- speclings lean 011: pattern matching (solution)

def size : Nat → String
  | 0 => "none"
  | 1 => "one"
  | _ => "many"

#guard size 0 == "none"
#guard size 1 == "one"
#guard size 5 == "many"

def minusTwo : Nat → Nat
  | 0 => 0
  | 1 => 0
  | n + 2 => n

#guard minusTwo 0 == 0
#guard minusTwo 1 == 0
#guard minusTwo 7 == 5
