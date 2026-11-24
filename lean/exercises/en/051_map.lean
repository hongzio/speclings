-- speclings lean 051: map
--
-- map applies a function to every element of a list. Its properties say
-- that mapping behaves well: mapping the identity changes nothing,
-- mapping twice is mapping once with both functions, and map goes
-- through append.
--
-- The proofs follow the same pattern as in 050: induction on the list,
-- then rewrite with the definitions and the induction hypothesis. The
-- functions f and g stay the same throughout; only the list gets smaller.

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
