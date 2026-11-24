-- leanlings 052: 보조 정리
--
-- 아래 reverse 는 첫 원소를 뒤집은 나머지의 끝에 붙입니다. 두 번
-- 뒤집으면 원래 리스트가 됩니다. reverse_reverse 를 바로 귀납법으로
-- 증명해 보세요. cons 경우의 목표는
--
--   reverse (append (reverse xs) [x]) = x :: xs
--
-- 이고, reverse (reverse xs) 에 관한 귀납 가정은 맞지 않습니다. 더 일반적인
-- 사실이 먼저 필요하다는 신호입니다. reverse 가 append 를 어떻게 다루는지.
-- reverse_append 를 증명하고, 그것을 쓰세요.
--
-- 050 의 append_nil 과 append_assoc 는 증명과 함께 주어져 있습니다. 다른
-- 정리처럼 rw 에서 쓰세요.

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def reverse {α : Type} : List α → List α
  | [] => []
  | x :: xs => append (reverse xs) [x]

theorem append_nil {α : Type} (xs : List α) : append xs [] = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => rw [append, ih]

theorem append_assoc {α : Type} (xs ys zs : List α) :
    append (append xs ys) zs = append xs (append ys zs) := by
  induction xs with
  | nil => rfl
  | cons x xs ih => rw [append, append, append, ih]

theorem reverse_append {α : Type} (xs ys : List α) :
    reverse (append xs ys) = append (reverse ys) (reverse xs) := by
  sorry

theorem reverse_reverse {α : Type} (xs : List α) : reverse (reverse xs) = xs := by
  sorry
