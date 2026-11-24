-- leanlings 004: goals (solution)

def double (n : Nat) : Nat := n + n

theorem two_plus_two : 2 + 2 = 4 := rfl

theorem double_three : double 3 = 6 := by
  rfl

theorem small : 3 < 5 := by
  decide

theorem both : double 2 = 4 ∧ 4 < double 3 := by
  constructor
  · rfl
  · decide
