-- speclings lean 062: vectors (solution)

inductive Vec (α : Type) : Nat → Type where
  | nil : Vec α 0
  | cons {n : Nat} : α → Vec α n → Vec α (n + 1)

namespace Vec

def head {α : Type} {n : Nat} : Vec α (n + 1) → α
  | cons x _ => x

def toList {α : Type} {n : Nat} : Vec α n → List α
  | nil => []
  | cons x xs => x :: xs.toList

def map {α β : Type} {n : Nat} (f : α → β) : Vec α n → Vec β n
  | nil => nil
  | cons x xs => cons (f x) (xs.map f)

def zip {α β : Type} {n : Nat} : Vec α n → Vec β n → Vec (α × β) n
  | nil, nil => nil
  | cons x xs, cons y ys => cons (x, y) (zip xs ys)

def append {α : Type} {m n : Nat} : Vec α m → Vec α n → Vec α (n + m)
  | nil, ys => ys
  | cons x xs, ys => cons x (append xs ys)

end Vec

def v3 : Vec Nat 3 := .cons 1 (.cons 2 (.cons 3 .nil))

#guard v3.head == 1
#guard (v3.map (· * 10)).toList == [10, 20, 30]
#guard (Vec.zip v3 v3).toList == [(1, 1), (2, 2), (3, 3)]
#guard (v3.append v3).toList == [1, 2, 3, 1, 2, 3]
