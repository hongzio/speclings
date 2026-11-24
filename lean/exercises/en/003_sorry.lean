-- speclings lean 003: sorry
--
-- sorry stands for something not written yet. Lean accepts it in place
-- of any value or proof, but warns:
--
--   warning: declaration uses `sorry`
--
-- (In 001, Lean put a sorry in place of a definition with an error.
-- That is why the messages of the #eval and the #guard mentioned it.)
--
-- From here on, exercises have sorrys for you to replace, and pass when
-- none is left. The rest of the file is given: change only the sorrys.
-- You may add things of your own, such as an #eval or a helper
-- definition.
--
-- #guard and #eval cannot run code that contains sorry. Until you fill
-- in a definition, Lean reports its #guards as errors too.
--
-- triple should multiply its argument by 3, and greet should greet
-- whoever it is given, as their #guards say.

def triple (n : Nat) : Nat := sorry

#guard triple 0 == 0
#guard triple 4 == 12

def greet (name : String) : String := sorry

#guard greet "Lean" == "Hello, Lean!"
#guard greet "world" == "Hello, world!"
