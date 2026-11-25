-- speclings lean 065: termination
--
-- In 012, Lean accepted functions that call themselves on a structurally
-- smaller argument. Euclid's algorithm does not: euclid a b calls
-- euclid b (a % b), and neither argument is a part of the previous ones.
-- It still terminates, because the second argument gets smaller: a % b is
-- less than b. You tell Lean what gets smaller with termination_by, after
-- the definition:
--
--   termination_by b
--
-- Lean then tries to prove that b decreases at each call. When it cannot,
-- it shows the goal it is left with, and decreasing_by proves it:
--
--   decreasing_by exact Nat.mod_lt a (Nat.pos_of_ne_zero h)
--
-- Nat.mod_lt a : b > 0 → a % b < b, and Nat.pos_of_ne_zero turns b ≠ 0
-- into b > 0. For that, the else branch needs the fact b ≠ 0 as a
-- hypothesis: if h : b = 0 then ... else ... names it, h : b = 0 in the
-- then branch and h : ¬b = 0 in the else branch.
--
-- Often Lean finds the measure on its own: for countUp below, it sees
-- that n - i decreases.
--
-- Fix euclid.

def euclid (a b : Nat) : Nat :=
  if b = 0 then a else euclid b (a % b)

#guard euclid 12 18 == 6
#guard euclid 7 0 == 7
#guard euclid 17 5 == 1

def countUp (i n : Nat) : List Nat :=
  if i < n then i :: countUp (i + 1) n else []

#guard countUp 2 5 == [2, 3, 4]
#guard countUp 5 2 == []
