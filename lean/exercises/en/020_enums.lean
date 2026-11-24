-- speclings lean 020: enumerations
--
-- inductive defines a new type by listing every way to build a value of
-- it, its constructors. With constructors that take nothing, that is just
-- a list of values:
--
--   inductive Weekday where
--     | monday
--     | tuesday
--     ...
--
-- The values are Weekday.monday, Weekday.tuesday, ... When Lean knows the
-- type it expects, .monday is enough. match tells the values apart, and
-- one case can cover several values: | .saturday | .sunday => ...
--
-- Fill in isWeekend, and next, which gives the following day.

inductive Weekday where
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  | sunday
  deriving Repr, BEq

def isWeekend : Weekday → Bool := sorry

#guard isWeekend .saturday
#guard isWeekend .sunday
#guard !isWeekend .monday

def next : Weekday → Weekday := sorry

#guard next .monday == .tuesday
#guard next .sunday == .monday
