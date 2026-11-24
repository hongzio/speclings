-- leanlings 043: for all (solution)

def Even (n : Nat) : Prop := n % 2 = 0

theorem even_four : Even 4 := rfl

theorem all_imp {α : Type} (P Q : α → Prop) (h1 : ∀ x, P x → Q x) (h2 : ∀ x, P x) : ∀ x, Q x := by
  intro x
  exact h1 x (h2 x)

theorem two_instances (P : Nat → Prop) (h : ∀ n, P n) : P 5 ∧ P 7 := ⟨h 5, h 7⟩

theorem forall_and_split {α : Type} (P Q : α → Prop) : (∀ x, P x ∧ Q x) → (∀ x, P x) ∧ (∀ x, Q x) := by
  intro h
  exact ⟨fun x => (h x).1, fun x => (h x).2⟩

theorem even_add_two (h : ∀ n, Even n → Even (n + 2)) : Even 6 := h 4 even_four
