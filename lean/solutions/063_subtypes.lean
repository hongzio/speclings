-- speclings lean 063: subtypes (solution)

def EvenNat := { n : Nat // n % 2 = 0 }

def four : EvenNat := ⟨4, rfl⟩

def ten : EvenNat := ⟨10, rfl⟩

def addEven (a b : EvenNat) : EvenNat :=
  ⟨a.val + b.val, by have := a.property; have := b.property; omega⟩

def double (n : Nat) : EvenNat := ⟨2 * n, by omega⟩

def half (e : EvenNat) : Nat := e.val / 2

#guard ten.val == 10
#guard (addEven four ten).val == 14
#guard (double 7).val == 14
#guard half (double 7) == 7

def PosNat := { n : Nat // n > 0 }

def divPos (a : Nat) (b : PosNat) : Nat := a / b.val

def three : PosNat := ⟨3, by decide⟩

#guard divPos 10 three == 3
