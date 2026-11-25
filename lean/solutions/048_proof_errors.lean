-- speclings lean 048: reading proof errors (solution)

theorem and_swap (p q : Prop) (h : p ∧ q) : q ∧ p :=
  ⟨h.2, h.1⟩

theorem or_swap (p q : Prop) (h : p ∨ q) : q ∨ p := by
  cases h with
  | inl hp => exact Or.inr hp
  | inr hq => exact Or.inl hq

theorem chain (p q r : Prop) (hpq : p → q) (hqr : q → r) (hp : p) : r := by
  apply hqr
  apply hpq
  exact hp

theorem both_parts (p q : Prop) (hp : p) (hq : q) : p ∧ q := by
  constructor
  · exact hp
  · exact hq

theorem undo_two (a b : Nat) (h : a + 2 = b) : b - 2 = a := by
  rw [← h, Nat.add_sub_cancel]
