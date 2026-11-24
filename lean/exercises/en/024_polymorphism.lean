-- leanlings 024: polymorphism
--
-- Some functions work the same for any type. Swapping a pair does not
-- care what is in it. A type can be an argument, written in braces:
--
--   def swap {α β : Type} (p : α × β) : β × α := ...
--
-- (type α as \a and β as \b.) The braces make α and β implicit: callers do
-- not pass them, and Lean works them out from p. swap (1, "a") uses
-- α := Nat and β := String. #check @swap shows the implicit arguments too.
--
-- Lean even adds implicit arguments by itself for undeclared names like α
-- (they are "auto-bound"), so def swap (p : α × β) works as well. These
-- exercises declare them anyway, to make them visible.
--
-- Types can take types as arguments too: List Nat, Option String. Tree α
-- below is a tree whose values have type α.
--
-- Fill in swap, mapOption (apply f to the value inside, if there is one)
-- and mapTree (apply f to every value of a tree).

def swap {α β : Type} (p : α × β) : β × α := sorry

#check @swap

#guard swap (1, "a") == ("a", 1)
#guard swap ("a", true) == (true, "a")

def mapOption {α β : Type} (f : α → β) : Option α → Option β := sorry

#guard mapOption (· + 1) (some 2) == some 3
#guard mapOption (· + 1) none == none
#guard mapOption toString (some 7) == some "7"

inductive Tree (α : Type) where
  | leaf
  | node (left : Tree α) (value : α) (right : Tree α)
  deriving Repr, BEq

def mapTree {α β : Type} (f : α → β) : Tree α → Tree β := sorry

#guard mapTree toString (.node .leaf 1 (.node .leaf 2 .leaf)) == .node .leaf "1" (.node .leaf "2" .leaf)
