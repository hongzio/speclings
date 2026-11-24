-- leanlings 028: 퀴즈 2
--
-- 이진 탐색 트리는 모든 노드가 왼쪽 하위 트리의 모든 값보다 크고, 오른쪽
-- 하위 트리의 모든 값보다 작은 트리입니다. 그러면 찾을 때 경로 하나만
-- 따라 내려가면 되고, 왼쪽부터 오른쪽으로 읽은 값들은 정렬되어 있습니다.
-- Part 7 에서 이것을 증명합니다.
--
-- 이름공간 Tree 안에서 다음을 채우세요:
--
--   insert     값을 제자리에 더합니다. 노드보다 작으면 왼쪽, 크면
--              오른쪽으로 갑니다. 이미 있는 값은 다시 더하지 않습니다
--   contains   트리에 값이 있는지. 경로 하나를 따라갑니다
--   toList     왼쪽부터 오른쪽으로 값들
--   ofList     리스트의 값들을 하나씩 잎(leaf)에 insert 해서 얻는 트리
--
-- (이름공간 안에서 l.insert x 는 다른 점 표기처럼 Tree.insert 를
-- 부릅니다.)

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
