-- speclings lean 017: 퀴즈 1
--
-- 이 퀴즈는 Part 1 의 내용을 조금씩 모두 씁니다.
--
-- digits n 은 n 의 십진 자릿수 리스트이고, 가장 높은 자리가 먼저입니다:
-- digits 2024 는 [2, 0, 2, 4], digits 0 은 [0]. (n / 10 은 n 의 마지막
-- 자리를 버리고, n % 10 은 그 자리입니다. n ≥ 10 일 때 n / 10 이 n 보다
-- 작다는 것은 Lean 이 알아서 압니다.)
--
-- digitSum n 은 n 의 자릿수의 합입니다.
--
-- fizzbuzz n 은 n 이 15 로 나누어떨어지면 "FizzBuzz", 3 으로
-- 나누어떨어지면 "Fizz", 5 로 나누어떨어지면 "Buzz", 아니면 n 을
-- String 으로 쓴 것입니다. fizzbuzzUpTo n 은 fizzbuzz 1, ..., fizzbuzz n
-- 의 리스트입니다.

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
