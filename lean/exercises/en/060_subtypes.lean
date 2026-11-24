-- speclings lean 060: subtypes
--
-- { n : Nat // n % 2 = 0 } is the type of the Nats n with n % 2 = 0: each
-- value is a pair of a number and a proof about it.
--
--   ⟨4, rfl⟩ : { n : Nat // n % 2 = 0 }     4 % 2 = 0 holds by computation
--   e.val                                     the number
--   e.property                                the proof, e.val % 2 = 0
--
-- A function that returns such a value must prove that the result has
-- the property, usually from the properties of its arguments. have names
-- a fact for the rest of a proof, so that omega can use it:
--
--   by have := a.property; omega
--
-- At run time, only the number remains: proofs cost nothing when the
-- program runs.
--
-- Fill in ten, addEven, double (2 * n) and three.

def EvenNat := { n : Nat // n % 2 = 0 }

def four : EvenNat := ⟨4, rfl⟩

def ten : EvenNat := sorry

def addEven (a b : EvenNat) : EvenNat := sorry

def double (n : Nat) : EvenNat := sorry

def half (e : EvenNat) : Nat := e.val / 2

#guard ten.val == 10
#guard (addEven four ten).val == 14
#guard (double 7).val == 14
#guard half (double 7) == 7

def PosNat := { n : Nat // n > 0 }

def divPos (a : Nat) (b : PosNat) : Nat := a / b.val

def three : PosNat := sorry

#guard divPos 10 three == 3
