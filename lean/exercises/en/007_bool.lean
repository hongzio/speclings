-- speclings lean 007: Bool
--
-- Bool has two values, true and false. Comparisons compute Bools:
--
--   a == b    equal             a != b    not equal
--   a < b     less than         a ≤ b     at most (type \le, or write <=)
--   x && y    and               x || y    or              !x    not
--
-- In 004 you met Prop, the type of statements: 2 + 2 = 4 is a Prop, a
-- claim to prove, while 2 + 2 == 4 is a Bool, a value to compute. When
-- Lean can decide a Prop by computing, it turns it into a Bool where it
-- expects one (decide (3 < 5) is true). That is why #guard 3 < 5 works
-- too, and why you see both = and ==.
--
-- Fill in isEven and isLeapYear. A year is a leap year if it is divisible
-- by 4, except for years divisible by 100, which are leap years only if
-- they are divisible by 400.

def isEven (n : Nat) : Bool := sorry

#guard isEven 0
#guard isEven 10
#guard !isEven 7

def isLeapYear (year : Nat) : Bool := sorry

#guard isLeapYear 2024
#guard !isLeapYear 2023
#guard !isLeapYear 1900
#guard isLeapYear 2000
