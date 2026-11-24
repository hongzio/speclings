-- speclings lean 034: strings (solution)

def wordCount (s : String) : Nat := ((s.splitOn " ").filter (· != "")).length

#guard wordCount "the quick brown fox" == 4
#guard wordCount "  spaced   out  " == 2
#guard wordCount "" == 0

def sumNumbers (s : String) : Nat := ((s.splitOn " ").filterMap String.toNat?).foldl (· + ·) 0

#guard sumNumbers "1 apple 2 pears 10" == 13

def onlyDigits (s : String) : String := String.ofList (s.toList.filter Char.isDigit)

#guard onlyDigits "a1b2c3" == "123"

def titleCase (s : String) : String := " ".intercalate ((s.splitOn " ").map String.capitalize)

#guard titleCase "hello lean world" == "Hello Lean World"
