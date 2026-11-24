-- speclings lean 050: 리스트에 대한 귀납법
--
-- 귀납법은 어떤 inductive 타입에서든 되고, 생성자마다 한 경우입니다.
-- 리스트라면:
--
--   induction xs with
--   | nil => ...              -- [] 에 대해 증명
--   | cons x xs ih => ...     -- x :: xs 에 대해 증명. ih 는 xs 에 대한 것
--
-- 아래 append 와 len 은 처음부터 직접 썼으므로, ++ 와 length 에 관한
-- 라이브러리의 정리가 적용되지 않습니다. 성질을 직접 증명합니다.
--
-- rw [append] 는 append 의 정의에 있는 등식 중 목표에 맞는 것으로 다시
-- 씁니다. append (x :: xs) ys 가 x :: append xs ys 가 됩니다. 손으로 하는
-- 계산 한 단계입니다.
--
-- len_append 에는 Nat 에 관한 정리 두 개가 도움이 됩니다:
--
--   Nat.zero_add n : 0 + n = n
--   Nat.add_right_comm a b c : a + b + c = a + c + b

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => len xs + 1

theorem append_nil {α : Type} (xs : List α) : append xs [] = xs := by
  sorry

theorem append_assoc {α : Type} (xs ys zs : List α) :
    append (append xs ys) zs = append xs (append ys zs) := by
  sorry

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  sorry
