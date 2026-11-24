-- leanlings 047: classical logic (solution)

theorem excluded_middle (p : Prop) : p ∨ ¬p := Classical.em p

theorem double_neg_elim (p : Prop) : ¬¬p → p := by
  intro hnn
  by_cases hp : p
  · exact hp
  · exact absurd hp hnn

theorem not_and_iff (p q : Prop) : ¬(p ∧ q) ↔ ¬p ∨ ¬q := by
  constructor
  · intro h
    by_cases hp : p
    · exact Or.inr (fun hq => h ⟨hp, hq⟩)
    · exact Or.inl hp
  · intro h ⟨hp, hq⟩
    rcases h with hnp | hnq
    · exact hnp hp
    · exact hnq hq

theorem imp_iff_or (p q : Prop) : (p → q) ↔ ¬p ∨ q := by
  constructor
  · intro h
    by_cases hp : p
    · exact Or.inr (h hp)
    · exact Or.inl hp
  · intro h hp
    rcases h with hnp | hq
    · exact absurd hp hnp
    · exact hq
