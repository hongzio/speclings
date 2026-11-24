def sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs + 1
#guard sum [] = 0
#guard sum [1, 2, 3] = 6
