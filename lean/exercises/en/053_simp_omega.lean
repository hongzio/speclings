-- leanlings 053: simp and omega
--
-- You have now taken the steps of many proofs by hand. Two tactics take
-- most of them for you, and from here on they are accepted:
--
--   omega        proves goals of linear arithmetic over Nat and Int: +,
--                -, multiplication by constants, <, ≤, = and the logic
--                around them, using the hypotheses
--   simp         rewrites the goal again and again with simp lemmas, many
--                of which come with Lean, until it is done or stuck
--   simp [f, h]  also unfolds the definition f and rewrites with h
--   simp [*]     also rewrites with all hypotheses, such as the ih
--
-- When simp leaves an arithmetic goal, omega can often finish it:
-- simp [...]; omega. To make simp use a theorem of your own, mark it with
-- @[simp] (as append_nil below).
--
-- Tactic combinators help too: t1 <;> t2 runs t2 on every goal t1 leaves,
-- so induction xs <;> simp [append, *] handles both cases at once.
--
-- Prove these with simp and omega. (grind and the search tactics, such as
-- exact?, are still not accepted.)

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => len xs + 1

theorem shuffle (a b c d : Nat) (h1 : a < b) (h2 : c ≤ d) : a + c < b + d + 1 := by
  sorry

theorem reverse_sum (a b c : Nat) : a + b + c = c + b + a := by
  sorry

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  sorry

@[simp] theorem append_nil {α : Type} (xs : List α) : append xs [] = xs := by
  sorry

theorem len_append_nil (xs : List Nat) : len (append xs []) = len xs := by
  sorry
