-- leanlings 054: generalizing
--
-- sumAcc adds up a list with an accumulator, the way a loop would: it
-- carries the sum so far in acc. sumTR, which starts it at 0, computes the
-- same as sum. (It is tail-recursive: it does not grow the stack.)
--
-- Prove sumAcc_eq by induction on xs. In the cons case, the goal is about
-- sumAcc xs (acc + x), but the induction hypothesis is about
-- sumAcc xs acc: the same acc as in the goal you started from, not
-- acc + x. Try it, and read what omega reports.
--
-- The fix is to prove the statement for every acc, so that the induction
-- hypothesis holds for every acc too:
--
--   induction xs generalizing acc with ...
--
-- revAcc does the same for reverse. Its proof can use the library's
-- theorems about reverse and ++, through simp.

def sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs

def sumAcc : List Nat → Nat → Nat
  | [], acc => acc
  | x :: xs, acc => sumAcc xs (acc + x)

def sumTR (xs : List Nat) : Nat := sumAcc xs 0

theorem sumAcc_eq (xs : List Nat) (acc : Nat) : sumAcc xs acc = acc + sum xs := by
  sorry

theorem sumTR_eq (xs : List Nat) : sumTR xs = sum xs := by
  sorry

def revAcc : List Nat → List Nat → List Nat
  | [], acc => acc
  | x :: xs, acc => revAcc xs (x :: acc)

theorem revAcc_eq (xs acc : List Nat) : revAcc xs acc = xs.reverse ++ acc := by
  sorry
