-- leanlings 005: natural numbers
--
-- Nat, the type of natural numbers 0, 1, 2, ..., is the default type of
-- number literals (#check 5 shows 5 : Nat). Its operations:
--
--   + * ^     as usual (2 ^ 10 is 2 to the power 10)
--   a / b     division, rounded down: the quotient, without the remainder
--   a % b     the remainder of a / b
--   a - b     subtraction. A Nat cannot be negative, so when b is larger
--             than a, the result is 0
--
-- Lean makes these operations total: they give a value for every input
-- instead of failing. Even a / 0 has a value, 0. (Theorems about / then
-- say when they hold, for example only when b > 0.)
--
-- Careful if you know Go or C: 3 - 5 is -2 there for signed integers,
-- and wraps around for unsigned ones. In Lean it is 0.
--
-- From here on, a sorry in a #guard is a blank: replace it with the value
-- you expect, such as 3 for 7 / 2. Work it out first, then check it with
-- an #eval of your own, such as #eval 7 / 2.

#guard 7 / 2 == sorry
#guard 7 % 2 == sorry
#guard 2 ^ 10 == sorry
#guard 3 - 5 == sorry
#guard 5 - 3 - 3 == sorry
#guard 10 - (5 - 3) == sorry
#guard 7 / 0 == sorry
#guard (7 / 2) * 2 + 7 % 2 == sorry
