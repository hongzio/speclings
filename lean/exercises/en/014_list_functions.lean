-- leanlings 014: functions on lists
--
-- Lists come with many functions. Several take a function as argument:
--
--   [1, 2, 3].map (· * 10)              [10, 20, 30]
--   [1, 2, 3, 4].filter (· % 2 == 0)    [2, 4]
--   [1, 2, 3].foldl (· + ·) 0           6, that is ((0 + 1) + 2) + 3
--   List.range 4                        [0, 1, 2, 3]
--
-- (· + ·) is fun a b => a + b: each · is the next argument.
--
-- xs.map f means List.map f xs: the dot calls a function from the
-- namespace of the type of xs, which is List, with xs as an argument.
--
-- |>. continues with the result of what comes before, so a pipeline
-- reads from left to right:
--
--   List.range 5 |>.filter (· % 2 == 0) |>.map (· * 10)    [0, 20, 40]
--
-- Fill in the functions below. Each fits on one line with map, filter,
-- foldl and List.range, without recursion.

def squares (n : Nat) : List Nat := sorry

#guard squares 4 == [0, 1, 4, 9]

def evens (xs : List Nat) : List Nat := sorry

#guard evens [1, 2, 3, 4, 6] == [2, 4, 6]

def product (xs : List Nat) : Nat := sorry

#guard product [2, 3, 4] == 24
#guard product [] == 1

-- the sum of the squares of the odd numbers below n
def sumOfOddSquares (n : Nat) : Nat := sorry

#guard sumOfOddSquares 6 == 35
