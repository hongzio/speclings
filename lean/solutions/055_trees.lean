-- leanlings 055: induction on trees (solution)

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
  induction t with
  | leaf => rfl
  | node l v r ihl ihr => simp [mirror, ihl, ihr]

theorem size_mirror (t : Tree) : t.mirror.size = t.size := by
  induction t with
  | leaf => rfl
  | node l v r ihl ihr => simp [mirror, size, ihl, ihr]; omega

theorem toList_mirror (t : Tree) : t.mirror.toList = t.toList.reverse := by
  induction t with
  | leaf => rfl
  | node l v r ihl ihr => simp [mirror, toList, ihl, ihr]

end Tree
