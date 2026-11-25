-- speclings lean 078: quiz 7 (solution)

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
  induction t <;> grind [insert, All]

theorem insert_bst (t : Tree) (x : Nat) (h : BST t) : BST (t.insert x) := by
  induction t <;> grind [insert, BST, All, all_insert]

theorem contains_insert (t : Tree) (x : Nat) : (t.insert x).contains x = true := by
  induction t <;> grind [insert, contains]

end Tree
