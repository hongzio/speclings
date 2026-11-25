-- speclings lean 077: when grind fails
--
-- When grind fails, it shows what it knew: its goal diagnostics. The
-- proofs below fail in three common ways. Read the diagnostics of each:
--
--   [facts] Asserted facts        what grind assumed or derived
--   [eqc] Equivalence classes     terms it found equal
--   [ematch] E-matching patterns  the theorems it could use
--   [cutsat] Assignment satisfying linear constraints
--        a counterexample: values for the terms that agree with every
--        fact grind has. A strange value, such as len [] := 1, shows a
--        fact that is missing: here, the definition of len.
--
-- Three ways out, one per proof:
--
--   grind [f]            when a definition is missing from the facts
--   induction, then grind    grind does not do induction (069): when the
--        goal is about a list it knows nothing about, choose the induction
--   grind [thm]          when a term stays stuck, such as sum (xs ++ ys):
--        prove a theorem about it first, then give it to grind
--
-- Fix each proof; keep the statements. Search tactics such as exact? do
-- not stay in the file.

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => 1 + len xs

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  induction xs <;> grind [append]

def ins (x : Nat) : List Nat → List Nat
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: ins x ys

theorem ins_length (x : Nat) (xs : List Nat) : (ins x xs).length = xs.length + 1 := by
  grind [ins]

def sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs

theorem sum_append (xs ys : List Nat) : sum (xs ++ ys) = sum xs + sum ys := by
  sorry

theorem sum_reverse (xs : List Nat) : sum xs.reverse = sum xs := by
  induction xs <;> grind [sum]
