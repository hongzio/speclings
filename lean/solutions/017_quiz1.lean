-- leanlings 017: quiz 1 (solution)

def digits (n : Nat) : List Nat :=
  if n < 10 then [n] else digits (n / 10) ++ [n % 10]

#guard digits 2024 == [2, 0, 2, 4]
#guard digits 7 == [7]
#guard digits 0 == [0]

def digitSum (n : Nat) : Nat := (digits n).foldl (· + ·) 0

#guard digitSum 2024 == 8

def fizzbuzz (n : Nat) : String :=
  if n % 15 == 0 then "FizzBuzz"
  else if n % 3 == 0 then "Fizz"
  else if n % 5 == 0 then "Buzz"
  else toString n

#guard fizzbuzz 9 == "Fizz"
#guard fizzbuzz 10 == "Buzz"
#guard fizzbuzz 30 == "FizzBuzz"
#guard fizzbuzz 7 == "7"

def fizzbuzzUpTo (n : Nat) : List String := (List.range n).map (fun i => fizzbuzz (i + 1))

#guard fizzbuzzUpTo 5 == ["1", "2", "Fizz", "4", "Buzz"]
