-- leanlings 013: lists (solution)

def len : List Nat → Nat
  | [] => 0
  | _ :: xs => 1 + len xs

#guard len [] == 0
#guard len [5, 6, 7] == 3

def total : List Nat → Nat
  | [] => 0
  | x :: xs => x + total xs

#guard total [] == 0
#guard total [1, 2, 3, 4] == 10

def has (xs : List Nat) (y : Nat) : Bool :=
  match xs with
  | [] => false
  | x :: rest => x == y || has rest y

#guard has [1, 2, 3] 2
#guard !has [1, 2, 3] 5
#guard !has [] 0
