-- speclings lean 022: trees
--
-- A constructor can also take values of the type being defined. A binary
-- tree is a leaf, or a node with a value and two smaller trees:
--
--   inductive Tree where
--     | leaf
--     | node (left : Tree) (value : Nat) (right : Tree)
--
-- sample below is this tree:
--
--         2
--        / \
--       1   3
--
-- A function on trees calls itself on the two subtrees, as a function on
-- lists calls itself on the rest of the list. Part 5 comes back to these
-- functions, to prove things about them.
--
-- Fill in size (the number of values), depth (the length of the longest
-- path from the top to a leaf; max a b is the larger of a and b), mirror
-- (left and right swapped everywhere) and toList (the values from left to
-- right).

inductive Tree where
  | leaf
  | node (left : Tree) (value : Nat) (right : Tree)
  deriving Repr, BEq

def sample : Tree := .node (.node .leaf 1 .leaf) 2 (.node .leaf 3 .leaf)

def size : Tree → Nat := sorry

#guard size .leaf == 0
#guard size sample == 3

def depth : Tree → Nat := sorry

#guard depth sample == 2
#guard depth (.node .leaf 1 (.node .leaf 2 (.node .leaf 3 .leaf))) == 3

def mirror : Tree → Tree := sorry

#guard mirror sample == .node (.node .leaf 3 .leaf) 2 (.node .leaf 1 .leaf)

def toList : Tree → List Nat := sorry

#guard toList sample == [1, 2, 3]
#guard toList (mirror sample) == [3, 2, 1]
