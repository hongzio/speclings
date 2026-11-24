-- speclings lean 055: 트리에 대한 귀납법
--
-- 022 의 트리 함수들입니다. 트리에 대한 귀납법은 생성자마다 한 경우이고,
-- 노드에는 하위 트리가 둘 있으므로 귀납 가정도 둘입니다:
--
--   induction t with
--   | leaf => ...
--   | node l v r ihl ihr => ...     -- l 에 대한 ihl, r 에 대한 ihr
--
-- (namespace Tree 안에서 mirror 는 Tree.mirror 를 뜻하고, 나머지도
-- 마찬가지입니다.)
--
-- toList_mirror 는 트리를 라이브러리의 List.reverse 와 연결합니다. simp 는
-- reverse 가 ++ 를 어떻게 통과하는지 압니다.

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
