-- leanlings 007: Bool (solution)

def isEven (n : Nat) : Bool := n % 2 == 0

#guard isEven 0
#guard isEven 10
#guard !isEven 7

def isLeapYear (year : Nat) : Bool :=
  year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)

#guard isLeapYear 2024
#guard !isLeapYear 2023
#guard !isLeapYear 1900
#guard isLeapYear 2000
