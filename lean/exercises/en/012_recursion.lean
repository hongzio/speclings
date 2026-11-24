-- leanlings 012: recursion
--
-- Lean has no loops in plain definitions (do blocks have them; see Part
-- 3). A function repeats by calling itself:
--
--   def factorial : Nat → Nat
--     | 0 => 1
--     | n + 1 => (n + 1) * factorial n
--
-- Lean must know that every function terminates. Otherwise its logic
-- would break: from a definition f n = f n + 1, you could prove 0 = 1.
-- It accepts factorial because each call is on a smaller argument, n
-- instead of n + 1. This is structural recursion. When Lean cannot see
-- why a function terminates, it reports "fail to show termination".
--
-- Fix sumTo: sumTo n is 0 + 1 + ... + n. Then fill in fib, the Fibonacci
-- numbers 0, 1, 1, 2, 3, 5, 8, ..., each the sum of the two before it.
-- (Replace the whole := sorry with cases, as in factorial.)

def sumTo : Nat → Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo (n + 1)

#guard sumTo 4 == 10

def fib : Nat → Nat := sorry

#guard fib 0 == 0
#guard fib 1 == 1
#guard fib 10 == 55
