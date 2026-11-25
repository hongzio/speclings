-- speclings lean 057: induction on trees
--
-- These are the tree functions of 022. Induction on a tree has one case
-- per constructor, and a node has two subtrees, so it comes with two
-- induction hypotheses:
--
--   induction t with
--   | leaf => ...
--   | node l v r ihl ihr => ...     -- ihl for l, ihr for r
--
-- (Inside namespace Tree, mirror means Tree.mirror, and so on.)
--
-- toList_mirror relates trees to the library's List.reverse: simp knows
-- how reverse goes through ++.

inductive Tree where
  | leaf
  | node (left : Tree) (value : Nat) (right : Tree)

namespace Tree

def size : Tree → Nat
  | leaf => 0
  | node l _ r => l.size + 1 + r.size

def mirror : Tree → Tree
  | leaf => leaf
  | node l v r => node r.mirror v l.mirror

def toList : Tree → List Nat
  | leaf => []
  | node l v r => l.toList ++ [v] ++ r.toList

theorem mirror_mirror (t : Tree) : t.mirror.mirror = t := by
  sorry

theorem size_mirror (t : Tree) : t.mirror.size = t.size := by
  sorry

theorem toList_mirror (t : Tree) : t.mirror.toList = t.toList.reverse := by
  sorry

end Tree
