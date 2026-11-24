-- speclings lean 038: apply (solution)

theorem chain (p q r s : Prop) (h1 : p → q) (h2 : q → r) (h3 : r → s) (hp : p) : s := by
  apply h3
  apply h2
  apply h1
  exact hp

theorem two_premises (p q r : Prop) (h : p → q → r) (hp : p) (hq : q) : r := by
  apply h
  · assumption
  · assumption

theorem pick (p q r : Prop) (hq : q) (h : q → r) (_ : p) : r := by
  apply h
  assumption
