-- speclings lean 078: quiz 7
--
-- The last exercise: the binary search tree of 028, proved correct.
--
-- BST t says that t is a binary search tree: at every node, all values on
-- the left are smaller, and all values on the right are larger. All p t
-- says that every value in t has the property p.
--
-- Prove that insert keeps a tree a binary search tree, and that contains
-- finds a value after it is inserted. For insert_bst, you need to know
-- that inserting a value with a property into a tree where all values
-- have it keeps that true: all_insert.
--
-- Each proof is an induction on t; grind, given the definitions it needs
-- (and all_insert), handles the cases.

inductive Tree where
  | leaf
  | node (left : Tree) (value : Nat) (right : Tree)

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

def All (p : Nat → Prop) : Tree → Prop
  | leaf => True
  | node l v r => All p l ∧ p v ∧ All p r

def BST : Tree → Prop
  | leaf => True
  | node l v r => All (· < v) l ∧ All (v < ·) r ∧ BST l ∧ BST r

theorem all_insert (p : Nat → Prop) (t : Tree) (x : Nat) (ht : All p t) (hx : p x) :
    All p (t.insert x) := by
  sorry

theorem insert_bst (t : Tree) (x : Nat) (h : BST t) : BST (t.insert x) := by
  sorry

theorem contains_insert (t : Tree) (x : Nat) : (t.insert x).contains x = true := by
  sorry

end Tree
