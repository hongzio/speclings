-- leanlings 028: quiz 2 (solution)

inductive Tree where
  | leaf
  | node (left : Tree) (value : Nat) (right : Tree)
  deriving Repr, BEq

namespace Tree

def insert (t : Tree) (x : Nat) : Tree :=
  match t with
  | leaf => node leaf x leaf
  | node l v r =>
    if x < v then node (l.insert x) v r
    else if v < x then node l v (r.insert x)
    else t

def contains (t : Tree) (x : Nat) : Bool :=
  match t with
  | leaf => false
  | node l v r => if x < v then l.contains x else if v < x then r.contains x else true

def toList : Tree → List Nat
  | leaf => []
  | node l v r => l.toList ++ [v] ++ r.toList

def ofList (xs : List Nat) : Tree := xs.foldl insert leaf

end Tree

#guard (Tree.ofList [3, 1, 2]).toList == [1, 2, 3]
#guard (Tree.ofList [5, 3, 8, 3, 1]).toList == [1, 3, 5, 8]
#guard (Tree.ofList [5, 3, 8]).contains 8
#guard !(Tree.ofList [5, 3, 8]).contains 4
#guard Tree.ofList [2, 1, 3] == .node (.node .leaf 1 .leaf) 2 (.node .leaf 3 .leaf)
