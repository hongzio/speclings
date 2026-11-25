-- speclings lean 075: invariants (solution)

def capacity : Nat := 3

structure State where
  items : Nat
  produced : Nat
  consumed : Nat

inductive Step : State → State → Prop where
  | produce (s : State) : s.items < capacity → Step s ⟨s.items + 1, s.produced + 1, s.consumed⟩
  | consume (s : State) : s.items > 0 → Step s ⟨s.items - 1, s.produced, s.consumed + 1⟩

inductive Reachable : State → Prop where
  | init : Reachable ⟨0, 0, 0⟩
  | step {s t : State} : Reachable s → Step s t → Reachable t

theorem bounded (s : State) (h : Reachable s) : s.items ≤ capacity := by
  induction h with
  | init => simp [capacity]
  | step _ hst ih => cases hst <;> simp_all <;> omega

theorem conserved (s : State) (h : Reachable s) : s.items + s.consumed = s.produced := by
  induction h with
  | init => rfl
  | step _ hst ih => cases hst <;> simp_all <;> omega

theorem consumed_le (s : State) (h : Reachable s) : s.consumed ≤ s.produced := by
  have := conserved s h
  omega
