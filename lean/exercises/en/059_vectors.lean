-- leanlings 059: vectors
--
-- A type can take a value as an argument. Vec α n is a list of exactly n
-- elements of type α:
--
--   inductive Vec (α : Type) : Nat → Type where
--     | nil : Vec α 0
--     | cons {n : Nat} : α → Vec α n → Vec α (n + 1)
--
-- The length is part of the type, so Lean checks it. head below takes a
-- Vec α (n + 1): it cannot be empty, so head needs no case for nil and no
-- Option. zip takes two vectors of the same length n. (The library has
-- Vector α n too, an Array with a proof of its size.)
--
-- For Lean, two types are the same when they compute to the same thing.
-- Vec α (2 + 1) is Vec α 3. But with a variable n, n + 0 computes to n,
-- while 0 + n does not compute at all: + takes apart its second argument,
-- as add did in 049. That is why add 0 n = n needed induction there, and
-- why append below does not compile: in the case nil, Lean needs ys to
-- have type Vec α (0 + n), and it does not see that this is Vec α n.
--
-- Fix the type of append, so that the lengths compute in both cases.
-- (Hint: in the case cons, the length is that of xs, plus 1.) Then fill
-- in map and zip.

inductive Vec (α : Type) : Nat → Type where
  | nil : Vec α 0
  | cons {n : Nat} : α → Vec α n → Vec α (n + 1)

namespace Vec

def head {α : Type} {n : Nat} : Vec α (n + 1) → α
  | cons x _ => x

def toList {α : Type} {n : Nat} : Vec α n → List α
  | nil => []
  | cons x xs => x :: xs.toList

def map {α β : Type} {n : Nat} (f : α → β) : Vec α n → Vec β n := sorry

def zip {α β : Type} {n : Nat} : Vec α n → Vec β n → Vec (α × β) n := sorry

def append {α : Type} {m n : Nat} : Vec α m → Vec α n → Vec α (m + n)
  | nil, ys => ys
  | cons x xs, ys => cons x (append xs ys)

end Vec

def v3 : Vec Nat 3 := .cons 1 (.cons 2 (.cons 3 .nil))

#guard v3.head == 1
#guard (v3.map (· * 10)).toList == [10, 20, 30]
#guard (Vec.zip v3 v3).toList == [(1, 1), (2, 2), (3, 3)]
#guard (v3.append v3).toList == [1, 2, 3, 1, 2, 3]
