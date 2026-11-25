-- speclings lean 075: 불변식
--
-- TLA+ (tla 트랙) 를 안다면 익숙해 보일 것입니다. 시스템은 상태의
-- 집합, 초기 상태, 상태 사이의 단계로 이루어집니다. 여기서는 생산자가
-- 용량 3 인 버퍼에 물건을 넣고, 소비자가 꺼냅니다:
--
--   Step s t        s 다음에 t 가 올 수 있음: produce (버퍼가 차지 않았으면)
--                   또는 consume (비어 있지 않으면)
--   Reachable s     초기 상태에서 단계들을 거쳐 s 에 도달할 수 있음
--
-- 불변식은 도달 가능한 모든 상태에서 성립합니다. TLC 는 도달 가능한 모든
-- 상태를 하나씩 해 봐서 확인하므로, 상태 공간이 유한하고 작아야 합니다.
-- Lean 은 Reachable 에 대한 귀납법으로 그 모두에 대해 한 번에
-- 증명합니다. 처음에 성립하고, 모든 단계가 그것을 유지한다고요.
--
--   induction h with
--   | init => ...                 -- 초기 상태
--   | step _ hst ih => ...        -- s 에서 t 로의 단계, s 에 대한 ih
--
-- step 경우에서 cases hst 는 단계의 종류마다 목표를 하나씩 줍니다. 그다음
-- simp_all 과 omega 가 마무리합니다.
--
-- 버퍼가 용량보다 많이 담지 않는다는 것, 그리고 잃는 것이 없다는 것, 곧
-- 생산된 것은 버퍼에 있거나 소비되었다는 것을 증명하세요.

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
