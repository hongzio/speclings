-- speclings lean 006: integers
--
-- Int is the type of integers ..., -2, -1, 0, 1, 2, ... A negative literal
-- needs a type, as in (-5 : Int), unless Lean already expects an Int there.
--
-- Int division rounds down too, toward minus infinity, and the remainder
-- is never negative: (-7 : Int) / 2 is -4. (Go's -7 / 2 is -3.)
--
-- To turn a Nat n into an Int, write (n : Int). Lean also does it for you
-- where it expects an Int:
--
--   def toInt (n : Nat) : Int := n
--
-- The other way loses information: Int.toNat turns a negative number
-- into 0, and Int.natAbs drops the sign.
--
-- let gives a name to a value inside a definition:
--
--   let diff := paid - price
--
-- Every value has one type, decided where it is computed. In change below,
-- paid and price are Nats, so diff is a Nat, computed with Nat
-- subtraction. Turning diff into an Int afterwards cannot bring back a
-- negative result.
--
-- Fill in the blanks. Then fix change: it should be negative when the
-- price is higher than what was paid.

#guard (-7 : Int) / 2 == sorry
#guard (-7 : Int) % 2 == sorry
#guard Int.toNat (-3) == sorry
#guard Int.natAbs (-3) == sorry

def change (paid price : Nat) : Int :=
  let diff := paid - price
  diff

#guard change 5 3 == 2
#guard change 3 5 == -2
