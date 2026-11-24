-- leanlings 004: goals
--
-- Lean is also a proof assistant. A theorem states a fact and proves it:
--
--   theorem name : statement := proof
--
-- The statement is a type, and the proof is a value of that type: Lean
-- checks a proof the way it checks any other definition. Statements
-- have type Prop (#check 2 + 2 = 4 shows 2 + 2 = 4 : Prop).
--
-- Two first proofs:
--
--   rfl      proves an equation whose two sides compute to the same
--            value ("reflexivity"): 2 + 2 = 4, double 3 = 6
--   decide   proves a statement Lean can decide by computing: 3 < 5
--
-- Most proofs are written with tactics. After by, each line is a step
-- that changes what is left to prove: the goal. Lean writes a goal as
--
--   ⊢ 2 + 2 = 4
--
-- Your editor shows the goal at the cursor (lean.nvim and VS Code call
-- this the infoview). In the terminal, Lean shows the goals left when a
-- proof is incomplete, as "unsolved goals". Try it: delete a sorry after
-- by, and run leanlings.
--
-- Some tactics turn a goal into several. constructor turns A ∧ B ("A and
-- B") into the two goals A and B, which you then prove one after the
-- other, each after a · (type \. in your editor, or write a plain .).
--
-- Replace every sorry. rfl works both as a proof (:= rfl) and as a
-- tactic (by rfl), but decide only works as a tactic (by decide).

def double (n : Nat) : Nat := n + n

theorem two_plus_two : 2 + 2 = 4 := sorry

theorem double_three : double 3 = 6 := by
  sorry

theorem small : 3 < 5 := by
  sorry

theorem both : double 2 = 4 ∧ 4 < double 3 := by
  constructor
  · sorry
  · sorry
