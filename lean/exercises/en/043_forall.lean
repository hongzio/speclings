-- speclings lean 043: for all
--
-- A statement can depend on a value. Even below is a predicate: for each
-- n, Even n is a statement, which holds when n % 2 = 0. Even 4 holds by
-- computation, so rfl proves it.
--
-- ∀ x, P x ("for all x, P x", type ∀ as \forall) is proved like an
-- implication: a proof of it is a function that takes any x and gives a
-- proof of P x. So intro x starts a proof of it, and h 5 applies an
-- h : ∀ n, P n to 5, giving a proof of P 5.
--
-- (α in all_imp is any type, as in 024. P and Q are predicates on it.)

def Even (n : Nat) : Prop := n % 2 = 0

theorem even_four : Even 4 := rfl

theorem all_imp {α : Type} (P Q : α → Prop) (h1 : ∀ x, P x → Q x) (h2 : ∀ x, P x) : ∀ x, Q x := by
  sorry

theorem two_instances (P : Nat → Prop) (h : ∀ n, P n) : P 5 ∧ P 7 := sorry

theorem forall_and_split {α : Type} (P Q : α → Prop) : (∀ x, P x ∧ Q x) → (∀ x, P x) ∧ (∀ x, Q x) := by
  sorry

theorem even_add_two (h : ∀ n, Even n → Even (n + 2)) : Even 6 := sorry
