-- leanlings 041: not (solution)

theorem double_neg_intro (p : Prop) : p → ¬¬p := by
  intro hp hnp
  exact hnp hp

theorem contrapositive (p q : Prop) : (p → q) → ¬q → ¬p := by
  intro hpq hnq hp
  exact hnq (hpq hp)

theorem not_and_left (p q : Prop) : ¬p → ¬(p ∧ q) := by
  intro hnp ⟨hp, _⟩
  exact hnp hp

theorem absurd_example (p q : Prop) : p → ¬p → q := by
  intro hp hnp
  exfalso
  exact hnp hp

theorem not_both (p : Prop) : ¬(p ∧ ¬p) := by
  intro ⟨hp, hnp⟩
  contradiction
