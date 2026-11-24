-- leanlings 020: enumerations (solution)

inductive Weekday where
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  | sunday
  deriving Repr, BEq

def isWeekend : Weekday → Bool
  | .saturday | .sunday => true
  | _ => false

#guard isWeekend .saturday
#guard isWeekend .sunday
#guard !isWeekend .monday

def next : Weekday → Weekday
  | .monday => .tuesday
  | .tuesday => .wednesday
  | .wednesday => .thursday
  | .thursday => .friday
  | .friday => .saturday
  | .saturday => .sunday
  | .sunday => .monday

#guard next .monday == .tuesday
#guard next .sunday == .monday
