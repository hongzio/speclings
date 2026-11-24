-- leanlings 016: pairs (solution)

def divMod (a b : Nat) : Nat × Nat := (a / b, a % b)

#guard divMod 7 2 == (3, 1)

def swap (p : Nat × String) : String × Nat := (p.2, p.1)

#guard swap (1, "one") == ("one", 1)

def sumPairs (xs : List (Nat × Nat)) : List Nat := xs.map (fun (a, b) => a + b)

#guard sumPairs [(1, 2), (3, 4)] == [3, 7]

def indexed (xs : List String) : List (Nat × String) := (List.range xs.length).zip xs

#guard indexed ["a", "b", "c"] == [(0, "a"), (1, "b"), (2, "c")]
