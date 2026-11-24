-- leanlings 072: 불변식 강화
--
-- 두 프로세스가 잠금 하나를 나눠 씁니다. 각 프로세스는 쉬고 있거나,
-- 기다리고 있거나, 임계 구역에 있습니다. 기다리는 프로세스는 잠금이 풀려
-- 있으면 잠금을 잡고 들어갈 수 있고, 나올 때 잠금을 풉니다. 상호 배제:
-- 둘이 동시에 임계 구역에 있는 일은 없습니다.
--
-- 071 처럼 mutex 를 바로 증명해 보세요. 프로세스 1 이 들어갈 때 막힙니다.
-- Lean 은 목표 ¬s.p2 = Pc.critical 을 보여 주는데, 아는 것은 잠금이 풀려
-- 있었다는 것뿐입니다. Mutex 만으로는 임계 구역에 있는 프로세스가 잠금을
-- 잡고 있다는 것을 말하지 않습니다. Mutex 는 도달 가능한 모든 상태에서
-- 참이지만, 귀납적이지는 않습니다. 성립하는 상태에서 한 단계 가면 깨질 수
-- 있습니다. 그 상태가 도달 가능하지 않다면요.
--
-- 해결책은 TLA+ 에서나 Lean 에서나 같습니다. 귀납적이면서 원하는 것을
-- 함의하는 더 강한 불변식입니다. LockInv 를 정의하세요. 임계 구역에 있는
-- 쪽은 잠금을 잡고 있다는 것, 그리고 Mutex. 그것을 귀납법으로 증명하고,
-- 거기서 mutex 를 얻으세요.

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
