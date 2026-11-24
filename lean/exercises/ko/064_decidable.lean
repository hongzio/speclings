-- speclings lean 064: 판정 가능한 명제
--
-- if c then ... 와 #guard c 에는 명제 c 이상의 것이 필요합니다. c 가
-- 성립하는지 계산하는 방법, 곧 Decidable c 의 instance 입니다. Lean 에는
-- Nat 의 =, < 같은 것과, 판정 가능한 명제들의 ∧, ∨, ¬ 에 대한 instance 가
-- 있습니다. 직접 정의한 명제라면 Lean 은 정의 안을 들여다보지 않으니,
-- instance 를 직접 줍니다.
--
-- 정의가 이미 판정 가능하면, inferInstanceAs 로 Lean 에게 그 정의를 펼친
-- 것의 instance 를 쓰라고 합니다:
--
--   instance (n : Nat) : Decidable (Even n) := inferInstanceAs (Decidable (n % 2 = 0))
--
-- 그렇지 않으면, 답을 계산하는 Bool 함수를 쓰고, 그것이 명제와 일치한다는
-- 것을 증명하고, 그것을 instance 로 바꾸는 것이 흔한 방법입니다:
--
--   decidable_of_iff _ (isSorted_iff xs) : Decidable (Sorted xs)
--
-- Even 의 instance, isSorted, 그것이 Sorted 와 일치한다는 증명
-- (fun_induction 다음 simp_all), Sorted 의 instance 를 채우세요.

def Even (n : Nat) : Prop := n % 2 = 0

instance (n : Nat) : Decidable (Even n) := sorry

#guard Even 4
#guard ¬ Even 7

def evens (xs : List Nat) : List Nat := xs.filter (fun n => decide (Even n))

#guard evens [1, 2, 3, 4] == [2, 4]

def Sorted : List Nat → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a ≤ b ∧ Sorted (b :: rest)

def isSorted : List Nat → Bool := sorry

theorem isSorted_iff (xs : List Nat) : isSorted xs = true ↔ Sorted xs := by
  sorry

instance : DecidablePred Sorted := sorry

#guard Sorted [1, 2, 2, 5]
#guard ¬ Sorted [3, 1]
