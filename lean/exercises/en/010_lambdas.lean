-- speclings lean 010: anonymous functions
--
-- fun x => e is a function without a name. (Instead of => you may write
-- ↦, typed \mapsto.)
--
--   fun x => x * 2             doubles its argument
--   fun (x : Nat) => x * 2     the same, with the type of x written out
--   (· * 2)                    the same, shorter: the · (type \.) is the argument
--
-- Functions are values. They can be passed to other functions, such as
-- List.map, which applies a function to every element of a list,
--
--   [1, 2, 3].map (fun x => x * 2)      [2, 4, 6]
--
-- and returned from them, like any other value.
--
-- Fix doubled. Then fill in twice: twice f x applies f to x two times.
-- And compose: compose g f is the function that applies f, then g.

def doubled (xs : List Nat) : List Nat := xs.map (fun x -> x * 2)

#guard doubled [1, 2, 3] == [2, 4, 6]

def twice (f : Nat → Nat) (x : Nat) : Nat := sorry

#guard twice (· + 3) 10 == 16
#guard twice (fun x => x * x) 3 == 81

def compose (g f : Nat → Nat) : Nat → Nat := sorry

#guard compose (· + 1) (· * 2) 5 == 11
#guard compose (· * 2) (· + 1) 5 == 12
