-- speclings lean 033: errors (solution)

deriving instance BEq for Except

def parseAge (s : String) : Except String Nat :=
  match s.toNat? with
  | none => throw s!"not a number: {s}"
  | some n => if n > 150 then throw s!"too old: {n}" else pure n

#guard parseAge "42" == .ok 42
#guard parseAge "x" == .error "not a number: x"
#guard parseAge "200" == .error "too old: 200"

def averageAge (a b : String) : Except String Nat := do
  let x ← parseAge a
  let y ← parseAge b
  return (x + y) / 2

#guard averageAge "20" "40" == .ok 30
#guard averageAge "20" "y" == .error "not a number: y"

def parseAll (xs : List String) : Except String (List Nat) := xs.mapM parseAge

#guard parseAll ["1", "2"] == .ok [1, 2]
#guard parseAll ["1", "x", "y"] == .error "not a number: x"
