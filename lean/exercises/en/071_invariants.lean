-- leanlings 071: invariants
--
-- If you know TLA+ (or tlings), this will look familiar. A system is a
-- set of states, an initial state and steps between states. Here, a
-- producer puts items into a buffer of capacity 3, and a consumer takes
-- them out:
--
--   Step s t        t can follow s: produce (if the buffer is not full)
--                   or consume (if it is not empty)
--   Reachable s     s can be reached from the initial state in steps
--
-- An invariant holds in every reachable state. TLC checks one by trying
-- every reachable state, so the state space must be finite and small.
-- Lean proves it for all of them at once, by induction on Reachable: it
-- holds initially, and every step keeps it.
--
--   induction h with
--   | init => ...                 -- the initial state
--   | step _ hst ih => ...        -- a step s to t, with ih for s
--
-- In the step case, cases hst gives one goal per kind of step; then
-- simp_all and omega finish them.
--
-- Prove that the buffer never holds more than its capacity, and that
-- nothing is lost: what was produced is either in the buffer or consumed.

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
  sorry

theorem conserved (s : State) (h : Reachable s) : s.items + s.consumed = s.produced := by
  sorry

theorem consumed_le (s : State) (h : Reachable s) : s.consumed ≤ s.produced := by
  sorry
