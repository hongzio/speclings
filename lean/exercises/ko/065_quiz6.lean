-- leanlings 065: 퀴즈 6
--
-- 이진 탐색은 정렬된 배열에서, 수가 있을 수 있는 부분을 반씩 줄여 가며
-- 수를 찾습니다. bsearch a x lo hi 는 위치 lo .. hi - 1 을 찾아보고, x 가
-- 있으면 그 위치를 돌려줍니다. 위치는 Fin a.size 로 오므로, 더 증명할
-- 것 없이 인덱스로 쓸 수 있습니다.
--
-- bsearch 를 쓰세요:
--
--   - lo < hi 이면 mid := (lo + hi) / 2 를 봅니다. a[mid] = x 이면 그것을
--     돌려주고, 아니면 x 가 있을 수 있는 반쪽을 찾습니다
--   - 아니면 x 는 없습니다
--
-- 필요한 것: Lean 이 mid 가 올바른 인덱스임을 증명할 수 있도록 의존
-- if (if hlt : lo < hi) (h : hi ≤ a.size 도 도움이 됨), 새 hi 가 여전히
-- a.size 이하라는 증명, 그리고 termination_by hi - lo. 산술은 omega 가
-- 하고, 인덱스와 종료에는 Lean 이 스스로 omega 를 시도합니다.
--
-- Part 7 에서 bsearch 가 정렬된 배열에 x 가 있으면 언제나 찾는다는 것을
-- 증명합니다.

def bsearch (a : Array Nat) (x : Nat) (lo hi : Nat) (h : hi ≤ a.size) : Option (Fin a.size) :=
  sorry

def find (a : Array Nat) (x : Nat) : Option Nat :=
  (bsearch a x 0 a.size (Nat.le_refl _)).map (·.val)

#guard find #[1, 3, 5, 7, 9] 7 == some 3
#guard find #[1, 3, 5, 7, 9] 1 == some 0
#guard find #[1, 3, 5, 7, 9] 9 == some 4
#guard find #[1, 3, 5, 7, 9] 4 == none
#guard find #[] 4 == none
