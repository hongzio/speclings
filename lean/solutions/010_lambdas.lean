-- leanlings 010: anonymous functions (solution)

def doubled (xs : List Nat) : List Nat := xs.map (fun x => x * 2)

#guard doubled [1, 2, 3] == [2, 4, 6]

def twice (f : Nat → Nat) (x : Nat) : Nat := f (f x)

#guard twice (· + 3) 10 == 16
#guard twice (fun x => x * x) 3 == 81

def compose (g f : Nat → Nat) : Nat → Nat := fun x => g (f x)

#guard compose (· + 1) (· * 2) 5 == 11
#guard compose (· * 2) (· + 1) 5 == 12
