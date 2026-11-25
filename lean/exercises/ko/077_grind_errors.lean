-- speclings lean 077: grind 가 실패할 때
--
-- grind 는 실패하면 알고 있던 것, 곧 목표 진단(goal diagnostics)을
-- 보여 줍니다. 아래 증명들은 흔한 세 가지 방식으로 실패합니다. 각각의
-- 진단을 읽으세요:
--
--   [facts] Asserted facts        grind 가 가정하거나 이끌어 낸 사실
--   [eqc] Equivalence classes     같다고 알아낸 항들
--   [ematch] E-matching patterns  쓸 수 있었던 정리들
--   [cutsat] Assignment satisfying linear constraints
--        반례: grind 가 가진 모든 사실과 맞는 항들의 값. len [] := 1 같은
--        이상한 값은 빠진 사실을 보여 줍니다. 여기서는 len 의 정의입니다.
--
-- 증명마다 하나씩, 세 가지 해결책:
--
--   grind [f]            정의가 사실에 빠져 있을 때
--   induction 다음 grind    grind 는 귀납법을 하지 않습니다 (069). 목표가
--        아무것도 모르는 리스트에 관한 것이면 귀납법을 고르세요
--   grind [thm]          sum (xs ++ ys) 처럼 항이 막혀 있을 때: 먼저 그에
--        관한 정리를 증명하고 grind 에 주세요
--
-- 명제는 그대로 두고 증명을 고치세요. exact? 같은 검색 전술은 파일에
-- 남지 않습니다.

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => 1 + len xs

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  induction xs <;> grind [append]

def ins (x : Nat) : List Nat → List Nat
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: ins x ys

theorem ins_length (x : Nat) (xs : List Nat) : (ins x xs).length = xs.length + 1 := by
  grind [ins]

def sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs

theorem sum_append (xs ys : List Nat) : sum (xs ++ ys) = sum xs + sum ys := by
  sorry

theorem sum_reverse (xs : List Nat) : sum xs.reverse = sum xs := by
  induction xs <;> grind [sum]
