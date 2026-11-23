-- leanlings 002: sorry (solution)

def double (n : Nat) : Nat := n + n

def triple (n : Nat) : Nat := 3 * n

#guard triple 0 == 0
#guard triple 4 == 12

theorem double_two : double 2 = 4 := rfl
