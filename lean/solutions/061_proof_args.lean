-- leanlings 061: proofs as arguments (solution)

def firstAndLast (xs : List Nat) (h : xs ≠ []) : Nat × Nat := (xs.head h, xs.getLast h)

#guard firstAndLast [3, 1, 4] (by simp) == (3, 4)

def second (xs : List Nat) (h : xs.length ≥ 2) : Nat := xs[1]

#guard second [5, 6, 7] (by decide) == 6

def middle (xs : List Nat) (h : xs.length > 0) : Nat := xs[xs.length / 2]

#guard middle [1, 2, 3] (by decide) == 2

def secondOfLong (xs : List Nat) (h : xs.length > 5) : Nat := second xs (by omega)

#guard secondOfLong [1, 2, 3, 4, 5, 6] (by decide) == 2
