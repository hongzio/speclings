-- leanlings 031: let mut and for (solution)

def total (xs : List Nat) : Nat := Id.run do
  let mut sum := 0
  for x in xs do
    sum := sum + x
  return sum

#guard total [1, 2, 3] == 6
#guard total [] == 0

def countdown (n : Nat) : List String := Id.run do
  let mut lines := []
  for i in List.range n do
    lines := toString (i + 1) :: lines
  return lines ++ ["liftoff!"]

#guard countdown 3 == ["3", "2", "1", "liftoff!"]
#guard countdown 0 == ["liftoff!"]

def main : IO Unit := do
  for line in countdown 3 do
    IO.println line
