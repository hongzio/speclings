-- leanlings 035: partial functions
--
-- The Collatz steps of n: if n is even, halve it, otherwise take 3n + 1,
-- and count the steps until 1. Starting from 6:
--
--   6, 3, 10, 5, 16, 8, 4, 2, 1       8 steps
--
-- Does this reach 1 for every n? Nobody knows: it is a famous open
-- problem. So Lean cannot be shown that collatz below terminates, and
-- rejects it (012 explains why it must).
--
-- partial def accepts a function without a termination proof, and Lean
-- can compile and run it. The price: Lean knows nothing about what a
-- partial function computes, so no theorem about it can be proved. (Its
-- return type must have some value, such as 0 for Nat, which Lean uses
-- as a stand-in.)
--
-- Fix collatz. Then fill in longestBelow n: the number below n with the
-- most steps, the smallest one if there is a tie.

def collatz (n : Nat) : Nat :=
  if n ≤ 1 then 0 else 1 + collatz (if n % 2 == 0 then n / 2 else 3 * n + 1)

#guard collatz 1 == 0
#guard collatz 6 == 8
#guard collatz 27 == 111

def longestBelow (n : Nat) : Nat := sorry

#guard longestBelow 10 == 9
#guard longestBelow 30 == 27
