-- leanlings 067: 사양
--
-- 프로그램이 올바르다는 것을 증명하려면, 먼저 올바르다는 것이 무슨
-- 뜻인지 말해야 합니다. 그것이 사양(specification)입니다. 정렬이라면 그
-- 일부는 결과가 정렬되어 있다는 것입니다. 여기서 Sorted 는 규칙들로,
-- 곧 귀납적 술어로 정의됩니다. 그 생성자들이 리스트가 정렬되어 있음을
-- 증명하는 방법들입니다.
--
--   Sorted.nil       [] 는 정렬됨
--   Sorted.single    [x] 는 정렬됨
--   Sorted.cons      x ≤ y 이고 y :: ys 가 정렬되어 있으면 x :: y :: ys 도
--
-- Sorted [1, 2, 3] 의 증명은 생성자로 값을 만들듯 규칙들로 만듭니다.
-- 증명 h : Sorted xs 를 풀면 (cases h) 그것을 만든 규칙과 그 전제들이
-- 나옵니다.
--
-- 그리고 induction h 는 h 가 어떻게 만들어졌는지에 대한 귀납법입니다.
-- 규칙마다 한 경우이고, 그 자체로 Sorted 인 전제마다 귀납 가정이
-- 있습니다. ins_sorted 를 증명하는 방법이 이것입니다. ins 는 정렬된
-- 리스트의 제자리에 x 를 넣습니다. 그러면 각 경우는 ins 와 규칙들을 받은
-- grind 의 몫입니다:
--
--   grind [ins, Sorted.nil, Sorted.single, Sorted.cons]

inductive Sorted : List Nat → Prop where
  | nil : Sorted []
  | single (x : Nat) : Sorted [x]
  | cons {x y : Nat} {ys : List Nat} : x ≤ y → Sorted (y :: ys) → Sorted (x :: y :: ys)

theorem sorted_123 : Sorted [1, 2, 3] :=
  sorry

theorem not_sorted_21 : ¬ Sorted [2, 1] := by
  sorry

def ins (x : Nat) : List Nat → List Nat
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: ins x ys

theorem ins_sorted (x : Nat) (xs : List Nat) (h : Sorted xs) : Sorted (ins x xs) := by
  sorry
