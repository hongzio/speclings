-- speclings lean 029: main
--
-- So far, Lean computed values. A program also does things: it prints,
-- reads files, talks to the network. In Lean, such a thing to do is a
-- value too, an action, with the type IO α: running it does something and
-- gives a result of type α. IO.println "hi" has type IO Unit: it prints,
-- and gives back nothing interesting (Unit has a single value, ()).
--
-- A program is the action named main, of type IO Unit. Run it with
--
--   lean --run work/029_main.lean
--
-- or write #eval main in the file. From here on, some exercises check
-- what main prints: speclings runs it and compares its output.
--
-- main below has the wrong type. Fix it, so that the program prints
-- Hello, speclings!

def greeting : String := "Hello, speclings!"

def main : Unit := IO.println greeting
