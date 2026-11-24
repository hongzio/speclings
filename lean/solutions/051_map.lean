-- leanlings 051: map (solution)

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def map {α β : Type} (f : α → β) : List α → List β
  | [] => []
  | x :: xs => f x :: map f xs

theorem map_id' {α : Type} (xs : List α) : map (fun x => x) xs = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => rw [map, ih]

theorem map_map {α β γ : Type} (f : α → β) (g : β → γ) (xs : List α) :
    map g (map f xs) = map (fun x => g (f x)) xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => rw [map, map, map, ih]

theorem map_append {α β : Type} (f : α → β) (xs ys : List α) :
    map f (append xs ys) = append (map f xs) (map f ys) := by
  induction xs with
  | nil => rfl
  | cons x xs ih => rw [append, map, map, append, ih]
