-- leanlings 025: namespaces (solution)

inductive Tree where
  | leaf
  | node (left : Tree) (value : Nat) (right : Tree)

def Tree.size : Tree → Nat
  | .leaf => 0
  | .node l _ r => size l + 1 + size r

def sample : Tree := .node .leaf 1 (.node .leaf 2 .leaf)

#guard sample.size == 2

namespace Tree

def sum : Tree → Nat
  | leaf => 0
  | node l v r => sum l + v + sum r

end Tree

#guard sample.sum == 3
#guard Tree.sum .leaf == 0
