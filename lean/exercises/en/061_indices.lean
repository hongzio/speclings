-- speclings lean 061: indices
--
-- Part 6 is about types that depend on values, and proofs inside
-- programs. The first example you have met already: xs[i] reads position
-- i of an array, and Lean must know that i < xs.size. Without a proof, it
-- refuses (032 used xs[i]? and xs[i]! to avoid that).
--
-- The proof can come from a hypothesis. A function can take one as an
-- argument:
--
--   def third (xs : Array Nat) (h : 2 < xs.size) : Nat := xs[2]
--
-- Lean finds h on its own when it checks xs[2]. (xs[i]'h names the proof
-- explicitly.) Callers then pass a proof, such as (by decide) for a fixed
-- array.
--
-- Fin n is the type of the Nats below n: a number together with a proof
-- that it is less than n. With i : Fin xs.size, xs[i] needs no other
-- proof. ⟨1, h⟩ builds a Fin from a number and the proof; i.val is the
-- number. Arithmetic on Fin n wraps around: it is computed modulo n.
--
-- Fix third, so that its #guard works. Then fill in the blanks.

def third (xs : Array Nat) : Nat := xs[2]

#guard third #[10, 20, 30] (by decide) == 30

def lookup (a : Array String) (i : Fin a.size) : String := a[i]

def days : Array String := #["mon", "tue", "wed"]

#guard lookup days ⟨1, by decide⟩ == "tue"

#guard ((3 : Fin 5) + 4).val == sorry
#guard (7 : Fin 5).val == sorry
#guard (Fin.last 4).val == sorry
