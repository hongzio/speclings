-- speclings lean 069: 이진 탐색
--
-- 065 의 bsearch 입니다. 이것이 건전하다는 것, 곧 위치를 돌려주면 그
-- 자리에 x 가 있다는 것을 증명하세요.
--
-- bsearch 는 구조적 재귀가 아니므로, fun_induction (056) 으로 들어갑니다.
-- 정의의 갈래마다 한 경우이고, 재귀 호출마다 귀납 가정이 있습니다.
--
--   case1   a[mid] = x 이고, 결과는 some ⟨mid, _⟩
--   case2   a[mid] < x: 오른쪽으로 계속 찾음
--   case3   그 밖: 왼쪽으로 계속 찾음
--   case4   lo ≥ hi 이고, 결과는 none
--
-- case1 에서 가정은 some ⟨mid, _⟩ = some i 라고 말합니다. 이것에 cases 를
-- 하면 i 가 ⟨mid, _⟩ 로 바뀝니다. case4 에서 none = some i 는
-- 불가능하므로, 그것에 simp at 을 하면 목표가 닫힙니다.
--
-- find_sound 는 그 결과입니다. bsearch 가 무엇을 돌려줬는지로 경우를
-- 나누고 (cases hb : ...), bsearch_sound 를 쓰세요.
--
-- 완전성, 곧 정렬된 배열에 x 가 있으면 bsearch 가 언제나 찾는다는 것도
-- 참이지만 증명하기는 훨씬 어렵습니다. x 가 어디에 있을 수 있는지 알아야
-- 하니까요.

def bsearch (a : Array Nat) (x : Nat) (lo hi : Nat) (h : hi ≤ a.size) : Option (Fin a.size) :=
  if hlt : lo < hi then
    let mid := (lo + hi) / 2
    if a[mid] = x then some ⟨mid, by omega⟩
    else if a[mid] < x then bsearch a x (mid + 1) hi h
    else bsearch a x lo mid (by omega)
  else none
termination_by hi - lo

def find (a : Array Nat) (x : Nat) : Option Nat :=
  (bsearch a x 0 a.size (Nat.le_refl _)).map (·.val)

theorem bsearch_sound (a : Array Nat) (x lo hi : Nat) (h : hi ≤ a.size) (i : Fin a.size)
    (hs : bsearch a x lo hi h = some i) : a[i] = x := by
  sorry

theorem find_sound (a : Array Nat) (x i : Nat) (h : find a x = some i) : a[i]? = some x := by
  sorry
