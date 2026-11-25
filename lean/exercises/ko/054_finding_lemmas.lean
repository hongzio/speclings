-- speclings lean 054: 정리 찾기
--
-- 지금까지는 문제에서 정의한 함수에 관한 사실을 증명했습니다. List.length,
-- List.reverse, Nat 의 산술 같은 라이브러리 함수에 대해서는 이미 수천 개의
-- 사실이 증명되어 있습니다. 그 이름을 알 일은 드물지만, Lean 이 찾아 줄 수
-- 있습니다:
--
--   exact?     목표를 증명하는 정리를 찾아 제안합니다:
--              Try this: exact List.length_append
--   apply?     같은 일을 하되, 증명할 목표를 남기는 정리도 찾습니다
--   rw?        목표에 쓸 수 있는 다시 쓰기를 나열합니다. 많으니 목표에
--              더 가까워지는 것을 고르세요
--   #check     이름의 명제를 보여 줍니다: #check @List.length_reverse
--
-- 이름에는 틀이 있습니다. 함수, 그다음 그 함수에 대해 정리가 말하는 것.
-- List.length_append 는 append 의 길이에 관한 것이고, List.reverse_reverse
-- 는 두 번 뒤집기에 관한 것입니다. 이름을 짐작하고 #check 로 확인하세요.
--
-- 검색 전술은 파일에 남지 않습니다. 각각을 그것이 제안한 것으로 바꾸세요.
-- speclings 는 검색 전술을 거부할 때 제안(Try this: ...)을 증명 순서대로
-- 보여 주고, 편집기는 각 증명 옆에 보여 줍니다. simp, omega 같은 자동
-- 전술은 아직 받아들이지 않습니다.

theorem len_append (xs ys : List Nat) : (xs ++ ys).length = xs.length + ys.length := by
  sorry

theorem rev_rev (xs : List Nat) : xs.reverse.reverse = xs := by
  sorry

theorem len_map (f : Nat → Nat) (xs : List Nat) : (xs.map f).length = xs.length := by
  sorry

theorem lt_le (a b : Nat) (h : a < b) : a ≤ b := by
  sorry

theorem sub_then_add (a b : Nat) (h : b ≤ a) : a - b + b = a := by
  sorry

theorem len_rev_append (xs ys : List Nat) : (xs ++ ys).reverse.length = ys.length + xs.length := by
  sorry
