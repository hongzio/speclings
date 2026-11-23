-- leanlings 002: sorry
--
-- sorry stands for something not written yet. Lean accepts it in place
-- of any value or proof, but warns:
--
--   warning: declaration uses `sorry`
--
-- From here on, exercises have sorrys for you to replace, and pass when
-- none is left. The rest of the file is given: change only the sorrys.
-- You may add things of your own, such as #eval or helper definitions.
--
-- triple below should multiply its argument by 3, as the #guards test.
-- They cannot run while triple is sorry, so until you fill it in, Lean
-- reports them as errors too.
--
-- Lean is also a proof assistant. A theorem states a fact and proves it:
--
--   theorem name : statement := proof
--
-- double_two states that double 2 is 4. That holds by computation:
-- double 2 is 2 + 2, which is 4. The proof rfl ("reflexivity") proves
-- an equation whose two sides compute to the same value. Replace the
-- sorry of double_two with rfl.

def double (n : Nat) : Nat := n + n

def triple (n : Nat) : Nat := sorry

#guard triple 0 == 0
#guard triple 4 == 12

theorem double_two : double 2 = 4 := sorry
