-- speclings lean 072: 사양 쓰기
--
-- 증명은 그 명제만큼만 의미가 있습니다. 071 에서 너무 약한 사양을
-- 보았습니다. "결과가 정렬되어 있다" 는 badSort 에도 성립합니다. 그러니
-- 사양으로 무엇을 증명하기 전에, 예로 시험하세요. 맞는 답은 받아들이고
-- 틀린 답은 거부해야 합니다.
--
-- IsMax xs m 은 m 이 xs 의 가장 큰 원소라는 뜻이어야 합니다. 아래 시험이
-- 성립하도록 쓰세요. 틀린 답은 모두 더 약한 사양이 통과시킬 답입니다:
--
--   [3, 1, 2] 에 5     모든 원소 이상이지만, 원소가 아님
--   [3, 1, 2] 에 1     원소이지만, 가장 크지 않음
--   [] 에 어떤 m       빈 리스트에는 가장 큰 원소가 없음
--
-- 그다음, 지금까지 가장 큰 원소를 들고 다니는 maxOf 가 그 사양을
-- 만족한다는 것을 증명하세요.
--
-- IsDedup xs ys 는 ys 가 xs 의 원소들을, 각각 한 번씩, 아무 순서로나
-- 가진다는 뜻이어야 합니다. "중복 없음" 만으로는 [] 도 받아들이고, "같은
-- 원소들" 만으로는 xs 자신도 받아들입니다.
--
-- 정의를 펼치면 decide 가 시험을 증명합니다 (unfold IsMax; decide). 단,
-- 정의가 ∀ x ∈ xs 와 ∃ x ∈ xs 만 쓸 때입니다. Lean 은 리스트를 훑어서
-- 그것들을 확인하지만, 모든 Nat 을 훑을 수는 없습니다. 라이브러리의
-- xs.Nodup 은 xs 에 중복이 없다는 뜻입니다.

def IsMax (xs : List Nat) (m : Nat) : Prop :=
  sorry

theorem max_example : IsMax [3, 1, 2] 3 := by
  sorry

theorem max_not_bound : ¬ IsMax [3, 1, 2] 5 := by
  sorry

theorem max_not_largest : ¬ IsMax [3, 1, 2] 1 := by
  sorry

theorem max_nil (m : Nat) : ¬ IsMax [] m := by
  sorry

def maxOf (x : Nat) : List Nat → Nat
  | [] => x
  | y :: ys => maxOf (max x y) ys

theorem maxOf_isMax (x : Nat) (xs : List Nat) : IsMax (x :: xs) (maxOf x xs) := by
  sorry

def IsDedup (xs ys : List Nat) : Prop :=
  sorry

theorem dedup_example : IsDedup [1, 2, 1, 3] [1, 2, 3] := by
  sorry

theorem dedup_any_order : IsDedup [1, 2, 1, 3] [3, 1, 2] := by
  sorry

theorem dedup_not_empty : ¬ IsDedup [1, 2, 1] [] := by
  sorry

theorem dedup_not_same : ¬ IsDedup [1, 2, 1] [1, 2, 1] := by
  sorry

theorem dedup_not_new : ¬ IsDedup [1, 2] [1, 2, 3] := by
  sorry
