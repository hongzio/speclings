-- speclings lean 017: quiz 1
--
-- This quiz uses a bit of everything from Part 1.
--
-- digits n is the list of the decimal digits of n, the most significant
-- first: digits 2024 is [2, 0, 2, 4], and digits 0 is [0]. (n / 10 drops
-- the last digit of n, and n % 10 is that digit. Lean sees on its own
-- that n / 10 is smaller than n when n ≥ 10.)
--
-- digitSum n is the sum of the digits of n.
--
-- fizzbuzz n is "FizzBuzz" if n is divisible by 15, "Fizz" if it is
-- divisible by 3, "Buzz" if it is divisible by 5, and n written as a
-- String otherwise. fizzbuzzUpTo n is the list of fizzbuzz 1, ...,
-- fizzbuzz n.

def digits (n : Nat) : List Nat := sorry

#guard digits 2024 == [2, 0, 2, 4]
#guard digits 7 == [7]
#guard digits 0 == [0]

def digitSum (n : Nat) : Nat := sorry

#guard digitSum 2024 == 8

def fizzbuzz (n : Nat) : String := sorry

#guard fizzbuzz 9 == "Fizz"
#guard fizzbuzz 10 == "Buzz"
#guard fizzbuzz 30 == "FizzBuzz"
#guard fizzbuzz 7 == "7"

def fizzbuzzUpTo (n : Nat) : List String := sorry

#guard fizzbuzzUpTo 5 == ["1", "2", "Fizz", "4", "Buzz"]
