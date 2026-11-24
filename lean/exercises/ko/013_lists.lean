-- speclings lean 013: 리스트
--
-- List Nat 은 Nat 의 나열입니다. 모든 리스트는 빈 리스트 [] 이거나,
-- 리스트 앞에 원소 하나를 붙인 x :: xs 입니다. [1, 2, 3] 은
-- 1 :: 2 :: 3 :: [] 를 줄여 쓴 것입니다.
--
-- 그래서 리스트에 대한 함수는 이 두 모양에 매칭하고, 더 작은 나머지
-- 리스트로 자신을 부릅니다:
--
--   def doubleAll : List Nat → List Nat
--     | [] => []
--     | x :: xs => (x * 2) :: doubleAll xs
--
-- ++ 는 두 리스트를 잇습니다: [1, 2] ++ [3] 은 [1, 2, 3].
--
-- len (원소 개수), total (원소의 합), has (수가 리스트에 있는지) 를 패턴
-- 매칭과 재귀로 채우세요. 리스트에는 이미 이런 함수(length, sum,
-- contains)가 있지만, 이 문제는 직접 쓰는 것이 목적입니다. 그래서 그
-- 함수들과 foldl, foldr, elem, any 는 받아들이지 않습니다.

def len : List Nat → Nat := sorry

#guard len [] == 0
#guard len [5, 6, 7] == 3

def total : List Nat → Nat := sorry

#guard total [] == 0
#guard total [1, 2, 3, 4] == 10

def has (xs : List Nat) (y : Nat) : Bool := sorry

#guard has [1, 2, 3] 2
#guard !has [1, 2, 3] 5
#guard !has [] 0
