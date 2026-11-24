-- leanlings 036: quiz 3 (solution)

def text : String := "the cat sat on the mat the end"

def countWords (words : List String) : List (String × Nat) :=
  words.foldl (init := []) fun counts w =>
    if counts.any (·.1 == w) then
      counts.map fun (v, c) => if v == w then (v, c + 1) else (v, c)
    else
      counts ++ [(w, 1)]

#guard countWords ["a", "b", "a"] == [("a", 2), ("b", 1)]
#guard countWords [] == []

def main : IO Unit := do
  for (word, count) in countWords (text.splitOn " ") do
    IO.println s!"{word}: {count}"
