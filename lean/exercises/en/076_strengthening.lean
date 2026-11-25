-- speclings lean 076: strengthening an invariant
--
-- Two processes share a lock. Each is idle, waiting, or in its critical
-- section. A waiting process may enter when the lock is free, taking it;
-- leaving releases it. Mutual exclusion: never both in their critical
-- sections.
--
-- Try to prove mutex as in 075, directly. It gets stuck when process 1
-- enters: Lean shows the goal ¬s.p2 = Pc.critical, and all it knows is
-- that the lock was free. Mutex alone does not say that a process in its
-- critical section holds the lock. It is true in every reachable state,
-- but it is not inductive: one step from a state where it holds may break
-- it, if that state is not reachable.
--
-- The way out, in TLA+ as in Lean, is a stronger invariant that is
-- inductive and implies the one you want. Define LockInv: whoever is in
-- the critical section has the lock, and Mutex. Prove it by induction,
-- then get mutex from it.

inductive Pc where
  | idle
  | waiting
  | critical
  deriving DecidableEq, Repr

structure State where
  p1 : Pc
  p2 : Pc
  locked : Bool

inductive Step : State → State → Prop where
  | request1 (s : State) : s.p1 = .idle → Step s { s with p1 := .waiting }
  | acquire1 (s : State) : s.p1 = .waiting → s.locked = false → Step s { s with p1 := .critical, locked := true }
  | release1 (s : State) : s.p1 = .critical → Step s { s with p1 := .idle, locked := false }
  | request2 (s : State) : s.p2 = .idle → Step s { s with p2 := .waiting }
  | acquire2 (s : State) : s.p2 = .waiting → s.locked = false → Step s { s with p2 := .critical, locked := true }
  | release2 (s : State) : s.p2 = .critical → Step s { s with p2 := .idle, locked := false }

inductive Reachable : State → Prop where
  | init : Reachable ⟨.idle, .idle, false⟩
  | step {s t : State} : Reachable s → Step s t → Reachable t

def Mutex (s : State) : Prop := ¬(s.p1 = .critical ∧ s.p2 = .critical)

def LockInv (s : State) : Prop := sorry

theorem lockInv_holds (s : State) (h : Reachable s) : LockInv s := by
  sorry

theorem mutex (s : State) (h : Reachable s) : Mutex s := by
  sorry
