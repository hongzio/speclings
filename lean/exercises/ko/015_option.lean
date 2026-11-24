-- speclings lean 015: Option
--
-- 빈 리스트의 첫 원소는 무엇일까요? 없습니다. 어떤 입력에는 답이 없는
-- 함수가 있고, Lean 은 그때 어떻게 할지 정하게 합니다. List.head 의
-- 타입을 보세요:
--
--   List.head : (xs : List α) → xs ≠ [] → α
--
-- 리스트 말고도, 리스트가 비어 있지 않다는 증명을 받습니다 (이런 함수는
-- Part 6 에서 다룹니다). 그 증명 없이 쓴 xs.head 는 아직 증명을 기다리는
-- 함수이고, 아래의 에러가 바로 그 말입니다.
--
-- 다른 방법은 Option α 를 돌려주는 것입니다. 값은 none 이거나, 어떤
-- x : α 에 대한 some x 입니다.
--
--   [5, 6].head?     some 5
--   [].head?         none
--
-- match 로 Option 을 풀어 볼 수 있고,
--
--   match xs.head? with
--   | none => 0
--   | some x => x
--
-- o.getD d 는 o 안의 값이고, o 가 none 이면 d 입니다.
--
-- first 를 고치세요. 그다음 firstOr 와 safeDiv 를 채우세요. safeDiv 는
-- (Lean 의 a / 0 = 0 대신) 0 으로 나눌 때 none 입니다.

def first (xs : List Nat) : Option Nat := xs.head

#guard first [] == none
#guard first [7, 8] == some 7

def firstOr (xs : List Nat) (fallback : Nat) : Nat := sorry

#guard firstOr [7, 8] 0 == 7
#guard firstOr [] 42 == 42

def safeDiv (a b : Nat) : Option Nat := sorry

#guard safeDiv 7 2 == some 3
#guard safeDiv 7 0 == none
