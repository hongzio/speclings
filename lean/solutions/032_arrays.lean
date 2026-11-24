-- speclings lean 032: arrays (solution)

def squaresArray (n : Nat) : Array Nat := Id.run do
  let mut out := #[]
  for i in List.range n do
    out := out.push (i * i)
  return out

#guard squaresArray 4 == #[0, 1, 4, 9]
#guard squaresArray 0 == #[]

def get (a : Array Nat) (i : Nat) : Nat := a[i]?.getD 0

#guard get #[10, 20] 1 == 20
#guard get #[10, 20] 5 == 0

def histogram (xs : List Nat) (buckets : Nat) : Array Nat := Id.run do
  let mut counts := Array.replicate buckets 0
  for x in xs do
    if x < buckets then
      counts := counts.modify x (· + 1)
  return counts

#guard histogram [0, 1, 1, 3, 1] 4 == #[1, 3, 0, 1]
#guard histogram [5, 0] 2 == #[1, 0]
