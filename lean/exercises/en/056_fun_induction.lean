-- speclings lean 056: functional induction
--
-- evens keeps every other element: evens [1, 2, 3, 4, 5] is [1, 3, 5]. It
-- does not follow the shape of a list one element at a time: it takes two
-- at a time.
--
-- So induction on xs gets stuck: in the cons case, x :: xs, the induction
-- hypothesis is about evens xs, but evens (x :: xs) is defined through
-- the list two elements shorter. Try it.
--
-- fun_induction follows the function instead: one case per case of its
-- definition, with an induction hypothesis wherever it calls itself:
--
--   fun_induction evens xs with
--   | case1 => ...                  -- xs = []
--   | case2 x => ...                -- xs = [x]
--   | case3 x y xs ih => ...        -- xs = x :: y :: xs, ih about evens xs
--
-- Then simp and omega finish each case.

def evens {α : Type} : List α → List α
  | [] => []
  | [x] => [x]
  | x :: _ :: xs => x :: evens xs

#guard evens [1, 2, 3, 4, 5] == [1, 3, 5]

theorem evens_le {α : Type} (xs : List α) : (evens xs).length ≤ xs.length := by
  sorry

theorem evens_half {α : Type} (xs : List α) : xs.length ≤ 2 * (evens xs).length := by
  sorry
