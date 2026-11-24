-- speclings lean 024: polymorphism (solution)

def swap {α β : Type} (p : α × β) : β × α := (p.2, p.1)

#check @swap

#guard swap (1, "a") == ("a", 1)
#guard swap ("a", true) == (true, "a")

def mapOption {α β : Type} (f : α → β) : Option α → Option β
  | none => none
  | some x => some (f x)

#guard mapOption (· + 1) (some 2) == some 3
#guard mapOption (· + 1) none == none
#guard mapOption toString (some 7) == some "7"

inductive Tree (α : Type) where
  | leaf
  | node (left : Tree α) (value : α) (right : Tree α)
  deriving Repr, BEq

def mapTree {α β : Type} (f : α → β) : Tree α → Tree β
  | .leaf => .leaf
  | .node l v r => .node (mapTree f l) (f v) (mapTree f r)

#guard mapTree toString (.node .leaf 1 (.node .leaf 2 .leaf)) == .node .leaf "1" (.node .leaf "2" .leaf)
