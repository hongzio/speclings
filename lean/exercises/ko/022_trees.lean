-- leanlings 022: 트리
--
-- 생성자는 지금 정의하는 타입의 값을 받을 수도 있습니다. 이진 트리는
-- 잎(leaf)이거나, 값 하나와 더 작은 트리 두 개를 가진 노드입니다:
--
--   inductive Tree where
--     | leaf
--     | node (left : Tree) (value : Nat) (right : Tree)
--
-- 아래 sample 은 이 트리입니다:
--
--         2
--        / \
--       1   3
--
-- 리스트에 대한 함수가 나머지 리스트로 자신을 부르듯, 트리에 대한 함수는
-- 두 하위 트리로 자신을 부릅니다. Part 5 에서 이 함수들로 돌아와 성질을
-- 증명합니다.
--
-- size (값의 개수), depth (맨 위에서 잎까지 가장 긴 경로의 길이.
-- max a b 는 a 와 b 중 큰 것), mirror (모든 곳에서 왼쪽과 오른쪽을
-- 바꿈), toList (왼쪽부터 오른쪽으로 값들) 를 채우세요.

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
