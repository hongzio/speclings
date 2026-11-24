-- speclings lean 045: 다시 쓰기
--
-- h : a = b 가 있으면, rw [h] 는 목표의 모든 a 를 b 로 바꿉니다. rw [← h]
-- (← 는 \l 로 입력) 는 b 를 a 로 바꿉니다. rw [h1, h2] 는 h1 로 바꾼 다음
-- h2 로 바꿉니다. 목표가 x = x 꼴이 되면 rw 가 목표를 닫습니다.
--
-- 라이브러리의 정리로도 다시 쓸 수 있습니다. Nat 에 관한 몇 가지:
--
--   Nat.add_zero n : n + 0 = n
--   Nat.add_comm a b : a + b = b + a
--   Nat.add_assoc a b c : a + b + c = a + (b + c)
--   Nat.add_sub_cancel : n + m - m = n
--
-- 인자를 주면 어느 부분을 바꿀지 고를 수 있습니다. rw [Nat.add_comm a b]
-- 는 a + b 만 바꾸고, rw [Nat.add_comm] 은 Lean 이 처음 찾은 합을
-- 바꿉니다. (#check Nat.add_comm 은 정리의 명제를 보여 줍니다.)

theorem eq_chain (a b c : Nat) (h1 : a = b) (h2 : b = c) : a = c := by
  sorry

theorem plus_zero (a b : Nat) (h : a = b + 1) : a + 0 = b + 1 := by
  sorry

theorem apply_both (f : Nat → Nat) (a b : Nat) (h : a = b) : f a = f b := by
  sorry

theorem reverse_sum (a b c : Nat) : a + b + c = c + b + a := by
  sorry

theorem undo_succ (a b : Nat) (h : a + 1 = b) : b - 1 = a := by
  sorry
