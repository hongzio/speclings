-- speclings lean 066: grind
--
-- Part 7, the last, proves programs correct. First, a stronger tool.
--
-- grind combines several kinds of reasoning, and keeps going until the
-- goal follows or nothing new can be learned:
--
--   - equalities: what is equal to what, and therefore f a = f b
--   - arithmetic: linear, as omega does, and also with products of
--     variables, like (a + b) * (a + b)
--   - case splits on if, match and the like
--   - grind [f] also unfolds the definition f; grind [thm] uses a theorem
--
-- grind does not do induction or generalization: you choose those, then
-- grind handles each case. When it fails, it lists the facts it knew: read
-- them to see what is missing.
--
-- Gauss's formula below, about sumTo from 012, is out of reach of the
-- tools of Part 5 (short of a long chain of rw): its step case has
-- products of variables, which omega does not do. Prove it, and the rest,
-- with grind.

def sumTo : Nat → Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo n

theorem gauss (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  sorry

theorem square_sum (a b : Nat) : (a + b) * (a + b) = a * a + 2 * a * b + b * b := by
  sorry

theorem odd_succ (x : Nat) (h : x % 2 = 1) : (x + 1) % 2 = 0 := by
  sorry

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => len xs + 1

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  sorry
