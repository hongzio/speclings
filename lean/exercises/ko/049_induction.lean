-- leanlings 049: 귀납법
--
-- Part 5 는 재귀 함수에 관한 것을 증명합니다. 여기 처음부터 직접 쓴
-- 덧셈이 있습니다. add m n 은 m 에 1 을 n 번 더합니다.
--
--   add m 0 = m
--   add m (n + 1) = add m n + 1
--
-- 두 등식은 정의에 따라 성립하므로 rfl 이 증명합니다 (아래에
-- add_zero' 와 add_succ' 로 주어져 있습니다). 하지만 add 0 n = n 은
-- 다릅니다. n 을 모르므로 Lean 은 add 0 n 을 계산할 수 없습니다. 모든 n
-- 에 대한 증명이 필요하고, 그것을 주는 것이 귀납법입니다:
--
--   induction n with
--   | zero => ...           -- 0 에 대해 증명
--   | succ n ih => ...      -- n + 1 에 대해 증명. ih: n 에 대해 성립함
--
-- 재귀 함수처럼, n + 1 에 대한 증명은 n 에 대한 증명을 쓸 수 있습니다.
-- rw [add_succ'] 는 주어진 등식으로 다시 쓰고, 그다음 rw [ih] 는 귀납
-- 가정으로 다시 씁니다.
--
-- succ_add' 와 add_comm' 도 같은 생각을 씁니다. add_comm' 에는 앞에서
-- 증명한 정리들도 필요합니다. 자동 전술은 아직 받아들이지 않습니다.

def add : Nat → Nat → Nat
  | m, 0 => m
  | m, n + 1 => add m n + 1

theorem add_zero' (m : Nat) : add m 0 = m := rfl

theorem add_succ' (m n : Nat) : add m (n + 1) = add m n + 1 := rfl

theorem zero_add' (n : Nat) : add 0 n = n := by
  sorry

theorem succ_add' (m n : Nat) : add (m + 1) n = add m n + 1 := by
  sorry

theorem add_comm' (m n : Nat) : add m n = add n m := by
  sorry
