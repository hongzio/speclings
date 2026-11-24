-- speclings lean 025: 이름공간
--
-- List.map f xs 대신 xs.map f 를 써 왔습니다. 점은 xs 의 타입인 List 를
-- 보고, List 타입 인자로 xs 를 넣어 함수 List.map 을 부릅니다. 그러니
-- t : Tree 에 대해 t.size 가 되려면 함수 Tree.size 가 있어야 합니다.
--
-- Tree.size 는 이름공간 Tree 안의 이름입니다. 전체 이름으로
-- def Tree.size ... 라고 쓰거나, 이 안에서 정의하세요:
--
--   namespace Tree
--   def size ...      -- Tree.size 를 정의
--   end Tree
--
-- 이름공간 안에서는 그 이름들을 Tree. 없이 쓸 수 있습니다: size, leaf,
-- node. 밖에서는 open Tree 가 같은 효과를 냅니다.
--
-- sample.size 가 되도록 size 를 고치세요. 그다음 트리의 값들의 합인
-- sum 을 채우세요.

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
