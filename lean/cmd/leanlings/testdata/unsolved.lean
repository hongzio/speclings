theorem t (p q : Prop) (hp : p) (hq : q) : p ∧ q := by
  constructor
  exact hp
