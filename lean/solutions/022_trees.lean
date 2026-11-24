-- leanlings 022: trees (solution)

inductive Tree where
  | leaf
  | node (left : Tree) (value : Nat) (right : Tree)
  deriving Repr, BEq

def sample : Tree := .node (.node .leaf 1 .leaf) 2 (.node .leaf 3 .leaf)

def size : Tree → Nat
  | .leaf => 0
  | .node l _ r => size l + 1 + size r

#guard size .leaf == 0
#guard size sample == 3

def depth : Tree → Nat
  | .leaf => 0
  | .node l _ r => 1 + max (depth l) (depth r)

#guard depth sample == 2
#guard depth (.node .leaf 1 (.node .leaf 2 (.node .leaf 3 .leaf))) == 3

def mirror : Tree → Tree
  | .leaf => .leaf
  | .node l v r => .node (mirror r) v (mirror l)

#guard mirror sample == .node (.node .leaf 3 .leaf) 2 (.node .leaf 1 .leaf)

def toList : Tree → List Nat
  | .leaf => []
  | .node l v r => toList l ++ [v] ++ toList r

#guard toList sample == [1, 2, 3]
#guard toList (mirror sample) == [3, 2, 1]
