-- leanlings 025: namespaces
--
-- You have used xs.map f for List.map f xs. The dot looks at the type of
-- xs, List, and calls the function List.map, with xs as the argument of
-- type List. So t.size works for a t : Tree when there is a function
-- Tree.size.
--
-- Tree.size is a name in the namespace Tree. Define it by writing the
-- full name, def Tree.size ..., or inside
--
--   namespace Tree
--   def size ...      -- this defines Tree.size
--   end Tree
--
-- Inside the namespace, its names can be used without Tree.: size, leaf,
-- node. Outside, open Tree has the same effect.
--
-- Fix size, so that sample.size works. Then fill in sum, the sum of the
-- values in a tree.

inductive Tree where
  | leaf
  | node (left : Tree) (value : Nat) (right : Tree)

def size : Tree → Nat
  | .leaf => 0
  | .node l _ r => size l + 1 + size r

def sample : Tree := .node .leaf 1 (.node .leaf 2 .leaf)

#guard sample.size == 2

namespace Tree

def sum : Tree → Nat := sorry

end Tree

#guard sample.sum == 3
#guard Tree.sum .leaf == 0
