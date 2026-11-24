-- speclings lean 035: partial (solution)

partial def collatz (n : Nat) : Nat :=
  if n ≤ 1 then 0 else 1 + collatz (if n % 2 == 0 then n / 2 else 3 * n + 1)

#guard collatz 1 == 0
#guard collatz 6 == 8
#guard collatz 27 == 111

def longestBelow (n : Nat) : Nat := Id.run do
  let mut best := 0
  for i in List.range n do
    if collatz i > collatz best then
      best := i
  return best

#guard longestBelow 10 == 9
#guard longestBelow 30 == 27
