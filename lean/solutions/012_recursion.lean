-- speclings lean 012: recursion (solution)

def sumTo : Nat → Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo n

#guard sumTo 4 == 10

def fib : Nat → Nat
  | 0 => 0
  | 1 => 1
  | n + 2 => fib n + fib (n + 1)

#guard fib 0 == 0
#guard fib 1 == 1
#guard fib 10 == 55
