-- speclings lean 030: do (solution)

def roll : IO Nat := pure 4

def main : IO Unit := do
  IO.println "Rolling..."
  let n ← roll
  IO.println s!"You rolled {n}, plus one is {n + 1}."
