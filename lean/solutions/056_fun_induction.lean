-- speclings lean 056: functional induction (solution)

def evens {α : Type} : List α → List α
  | [] => []
  | [x] => [x]
  | x :: _ :: xs => x :: evens xs

#guard evens [1, 2, 3, 4, 5] == [1, 3, 5]

theorem evens_le {α : Type} (xs : List α) : (evens xs).length ≤ xs.length := by
  fun_induction evens xs with
  | case1 => simp
  | case2 x => simp
  | case3 x y xs ih => simp; omega

theorem evens_half {α : Type} (xs : List α) : xs.length ≤ 2 * (evens xs).length := by
  fun_induction evens xs with
  | case1 => simp
  | case2 x => simp
  | case3 x y xs ih => simp; omega
