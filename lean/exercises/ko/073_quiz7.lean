-- leanlings 073: 퀴즈 7
--
-- 마지막 문제: 028 의 이진 탐색 트리가 올바르다는 증명입니다.
--
-- BST t 는 t 가 이진 탐색 트리라는 것입니다. 모든 노드에서 왼쪽의 모든
-- 값은 더 작고, 오른쪽의 모든 값은 더 큽니다. All p t 는 t 의 모든 값이
-- 성질 p 를 가진다는 것입니다.
--
-- insert 가 이진 탐색 트리를 이진 탐색 트리로 유지한다는 것, 그리고 값을
-- 넣은 뒤에 contains 가 그 값을 찾는다는 것을 증명하세요. insert_bst 에는
-- 모든 값이 어떤 성질을 가진 트리에 그 성질을 가진 값을 넣어도 여전히
-- 그렇다는 것, 곧 all_insert 가 필요합니다.
--
-- 각 증명은 t 에 대한 귀납법이고, 필요한 정의들 (과 all_insert) 를 받은
-- grind 가 경우들을 처리합니다.

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
