-- speclings lean 014: 리스트 함수
--
-- 리스트에는 함수가 많습니다. 함수를 인자로 받는 것도 여럿입니다:
--
--   [1, 2, 3].map (· * 10)              [10, 20, 30]
--   [1, 2, 3, 4].filter (· % 2 == 0)    [2, 4]
--   [1, 2, 3].foldl (· + ·) 0           6, 즉 ((0 + 1) + 2) + 3
--   List.range 4                        [0, 1, 2, 3]
--
-- (· + ·) 는 fun a b => a + b 입니다. 각 · 이 다음 인자입니다.
--
-- xs.map f 는 List.map f xs 라는 뜻입니다. 점은 xs 의 타입인 List 의
-- 이름공간에서 함수를 찾아, xs 를 인자로 넣어 부릅니다.
--
-- |>. 는 앞의 결과에 이어서 부르므로, 처리 과정을 왼쪽에서 오른쪽으로
-- 읽을 수 있습니다:
--
--   List.range 5 |>.filter (· % 2 == 0) |>.map (· * 10)    [0, 20, 40]
--
-- 아래 함수들을 채우세요. 모두 재귀 없이 map, filter, foldl,
-- List.range 로 한 줄에 쓸 수 있습니다.

def squares (n : Nat) : List Nat := sorry

#guard squares 4 == [0, 1, 4, 9]

def evens (xs : List Nat) : List Nat := sorry

#guard evens [1, 2, 3, 4, 6] == [2, 4, 6]

def product (xs : List Nat) : Nat := sorry

#guard product [2, 3, 4] == 24
#guard product [] == 1

-- n 보다 작은 홀수들의 제곱의 합
def sumOfOddSquares (n : Nat) : Nat := sorry

#guard sumOfOddSquares 6 == 35
