-- speclings lean 072: strengthening an invariant (solution)

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

def LockInv (s : State) : Prop :=
  (s.p1 = .critical → s.locked = true) ∧ (s.p2 = .critical → s.locked = true) ∧ Mutex s

theorem lockInv_holds (s : State) (h : Reachable s) : LockInv s := by
  induction h with
  | init => simp [LockInv, Mutex]
  | step _ hst ih => cases hst <;> simp_all [LockInv, Mutex]

theorem mutex (s : State) (h : Reachable s) : Mutex s := (lockInv_holds s h).2.2
