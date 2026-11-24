-------------------------- MODULE 010_quantifiers ---------------------------
EXTENDS Integers
\* tlings 010: \A and \E
\*
\*   \A x \in S : P     P holds for every x in S       ("for all")
\*   \E x \in S : P     P holds for at least one x     ("there exists")
\*
\* Think of them as loops that return a boolean:
\*
\*   \A:  for x in S { if !P { return false } }; return true
\*   \E:  for x in S { if P { return true } }; return false
\*
\* So over the empty set, \A is TRUE and \E is FALSE.
\*
\* Most invariants are \A formulas: "every account has a balance >= 0".
\* Several variables at once: \A x, y \in S : P.
\*
\* Write the two definitions so that the ASSUMEs hold.

\* every element of S is positive
AllPositive(S) == ???

\* some element of S is greater than n
SomeAbove(S, n) == ???

ASSUME AllPositive({1, 2, 3})
ASSUME ~AllPositive({1, -2, 3})
ASSUME AllPositive({})
ASSUME SomeAbove({1, 5, 3}, 4)
ASSUME ~SomeAbove({1, 2}, 4)
ASSUME ~SomeAbove({}, 0)

=============================================================================
