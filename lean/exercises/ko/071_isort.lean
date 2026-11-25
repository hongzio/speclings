-- speclings lean 071: 삽입 정렬
--
-- isort 는 리스트의 원소를 하나씩 정렬된 리스트에 넣어서 정렬합니다. 그
-- 결과는 정렬되어 있습니다. 이것은 (주어진) 070 의 ins_sorted 로부터
-- 따라 나옵니다.
--
-- 하지만 "결과가 정렬되어 있다" 는 좋은 사양일까요? 아래 badSort 는
-- 언제나 [] 를 돌려주는데, 이것도 정렬되어 있습니다. 정렬은 원소들도
-- 지켜야 합니다. 결과는 입력의 순열, 곧 같은 원소들을 어떤 순서로 놓은
-- 것이어야 합니다. 라이브러리는 이것을 List.Perm 으로 정의하고,
-- l₁.Perm l₂ 로 씁니다. 그 규칙들 중 몇 가지:
--
--   List.Perm.refl l : l.Perm l
--   h.cons x : (x :: l₁).Perm (x :: l₂)      h : l₁.Perm l₂ 일 때
--   List.Perm.swap x y l : (y :: x :: l).Perm (x :: y :: l)
--   h₁.trans h₂ : l₁.Perm l₃       h₁ : l₁.Perm l₂, h₂ : l₂.Perm l₃ 일 때
--   h.length_eq : l₁.length = l₂.length
--
-- isort 가 정렬되어 있고 순열이라는 것, 그리고 badSort 는 순열이 아니라는
-- 것을 증명하세요. ins_perm 에서 x 가 y 뒤로 가는 경우는 y :: ins x ys
-- 이고, 이것은 y :: x :: ys 의 순열이며, 그것은 x :: y :: ys 의
-- 순열입니다.

inductive Sorted : List Nat → Prop where
  | nil : Sorted []
  | single (x : Nat) : Sorted [x]
  | cons {x y : Nat} {ys : List Nat} : x ≤ y → Sorted (y :: ys) → Sorted (x :: y :: ys)

def ins (x : Nat) : List Nat → List Nat
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: ins x ys

theorem ins_sorted (x : Nat) (xs : List Nat) (h : Sorted xs) : Sorted (ins x xs) := by
  induction h <;> grind [ins, Sorted.nil, Sorted.single, Sorted.cons]

def isort : List Nat → List Nat
  | [] => []
  | x :: xs => ins x (isort xs)

theorem isort_sorted (xs : List Nat) : Sorted (isort xs) := by
  sorry

theorem ins_perm (x : Nat) (xs : List Nat) : (ins x xs).Perm (x :: xs) := by
  sorry

theorem isort_perm (xs : List Nat) : (isort xs).Perm xs := by
  sorry

def badSort (_ : List Nat) : List Nat := []

theorem badSort_sorted (xs : List Nat) : Sorted (badSort xs) := .nil

theorem badSort_not_perm : ¬ (badSort [1]).Perm [1] := by
  sorry
