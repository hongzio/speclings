-- leanlings 037: implication (solution)

theorem self_imp (p : Prop) : p → p := fun hp => hp

theorem modus_ponens (p q : Prop) (hp : p) (hpq : p → q) : q := hpq hp

theorem imp_trans (p q r : Prop) (hpq : p → q) (hqr : q → r) : p → r := by
  intro hp
  exact hqr (hpq hp)

theorem const_imp (p q : Prop) : p → q → p := by
  intro hp _
  exact hp
