-- speclings lean 028: quiz 2
--
-- A binary search tree is a tree in which every node is larger than all
-- values in its left subtree and smaller than all values in its right
-- subtree. Then a search only needs to follow one path down, and the
-- values from left to right are sorted. Part 7 proves that.
--
-- Fill in, in the namespace Tree:
--
--   insert     adds a value at its place: go left if it is smaller than
--              the node, right if it is larger. A value already there is
--              not added again
--   contains   whether the tree has a value, following one path
--   toList     the values from left to right
--   ofList     the tree you get by inserting the values of a list, one by
--              one, into a leaf
--
-- (In the namespace, l.insert x calls Tree.insert, like any dot.)

inductive Tree where
  | leaf
  | node (left : Tree) (value : Nat) (right : Tree)
  deriving Repr, BEq

namespace Tree

def insert (t : Tree) (x : Nat) : Tree := sorry

def contains (t : Tree) (x : Nat) : Bool := sorry

def toList : Tree → List Nat := sorry

def ofList (xs : List Nat) : Tree := sorry

end Tree

#guard (Tree.ofList [3, 1, 2]).toList == [1, 2, 3]
#guard (Tree.ofList [5, 3, 8, 3, 1]).toList == [1, 3, 5, 8]
#guard (Tree.ofList [5, 3, 8]).contains 8
#guard !(Tree.ofList [5, 3, 8]).contains 4
#guard Tree.ofList [2, 1, 3] == .node (.node .leaf 1 .leaf) 2 (.node .leaf 3 .leaf)
