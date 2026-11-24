-- speclings lean 051: map
--
-- map 은 리스트의 모든 원소에 함수를 적용합니다. 그 성질들은 map 이 잘
-- 행동한다는 것을 말합니다. 항등 함수를 map 하면 아무것도 바뀌지 않고,
-- 두 번 map 하는 것은 두 함수를 합쳐 한 번 map 하는 것이며, map 은
-- append 를 통과합니다.
--
-- 증명은 050 과 같은 틀을 따릅니다. 리스트에 대한 귀납법 다음, 정의와
-- 귀납 가정으로 다시 쓰기. 함수 f 와 g 는 내내 그대로이고, 리스트만
-- 작아집니다.

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def map {α β : Type} (f : α → β) : List α → List β
  | [] => []
  | x :: xs => f x :: map f xs

theorem map_id' {α : Type} (xs : List α) : map (fun x => x) xs = xs := by
  sorry

theorem map_map {α β γ : Type} (f : α → β) (g : β → γ) (xs : List α) :
    map g (map f xs) = map (fun x => g (f x)) xs := by
  sorry

theorem map_append {α β : Type} (f : α → β) (xs ys : List α) :
    map f (append xs ys) = append (map f xs) (map f ys) := by
  sorry
