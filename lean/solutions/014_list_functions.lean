-- speclings lean 014: functions on lists (solution)

def squares (n : Nat) : List Nat := (List.range n).map (· ^ 2)

#guard squares 4 == [0, 1, 4, 9]

def evens (xs : List Nat) : List Nat := xs.filter (· % 2 == 0)

#guard evens [1, 2, 3, 4, 6] == [2, 4, 6]

def product (xs : List Nat) : Nat := xs.foldl (· * ·) 1

#guard product [2, 3, 4] == 24
#guard product [] == 1

def sumOfOddSquares (n : Nat) : Nat :=
  List.range n |>.filter (· % 2 == 1) |>.map (· ^ 2) |>.foldl (· + ·) 0

#guard sumOfOddSquares 6 == 35
