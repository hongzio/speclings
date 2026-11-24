-- speclings lean 056: 함수 귀납법
--
-- evens 는 원소를 하나 걸러 남깁니다: evens [1, 2, 3, 4, 5] 는
-- [1, 3, 5]. 이 함수는 리스트의 모양을 한 원소씩 따라가지 않고, 두 개씩
-- 가져갑니다.
--
-- 그래서 xs 에 대한 귀납법은 막힙니다. cons 경우 x :: xs 에서 귀납 가정은
-- evens xs 에 관한 것인데, evens (x :: xs) 는 두 원소 짧은 리스트로
-- 정의됩니다. 해 보세요.
--
-- fun_induction 은 대신 함수를 따라갑니다. 정의의 경우마다 한 경우이고,
-- 함수가 자신을 부르는 곳마다 귀납 가정이 있습니다:
--
--   fun_induction evens xs with
--   | case1 => ...                  -- xs = []
--   | case2 x => ...                -- xs = [x]
--   | case3 x y xs ih => ...        -- xs = x :: y :: xs, ih 는 evens xs 에 관한 것
--
-- 그다음 simp 와 omega 가 각 경우를 마무리합니다.

def evens {α : Type} : List α → List α
  | [] => []
  | [x] => [x]
  | x :: _ :: xs => x :: evens xs

#guard evens [1, 2, 3, 4, 5] == [1, 3, 5]

theorem evens_le {α : Type} (xs : List α) : (evens xs).length ≤ xs.length := by
  sorry

theorem evens_half {α : Type} (xs : List α) : xs.length ≤ 2 * (evens xs).length := by
  sorry
