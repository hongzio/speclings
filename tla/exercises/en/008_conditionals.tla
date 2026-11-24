-------------------------- MODULE 008_conditionals --------------------------
EXTENDS Integers
\* speclings tla 008: IF, CASE and LET
\*
\*   IF c THEN a ELSE b    an expression, not a statement: it has a value,
\*                         so ELSE is required
\*
\*   CASE c1 -> a          the value for a condition that is true.
\*     [] c2 -> b          If several are true, TLA+ does not say which one
\*     [] OTHER -> d       is used, so make them exclusive. OTHER applies
\*                         when none is true; without it, that is an error.
\*
\*   LET x == e IN body    a definition that exists only inside body
\*
\* There are three bugs below, and TLC reports them one at a time.

Abs(x) == IF x < 0 THEN -x

Sign(x) == CASE x > 0 -> 1
             [] x < 0 -> -1

\* the distance between a and b
Dist(a, b) == LET d == ??? IN Abs(d)

ASSUME Abs(-3) = 3
ASSUME Abs(2) = 2
ASSUME Sign(-5) = -1
ASSUME Sign(0) = 0
ASSUME Dist(2, 7) = 5
ASSUME Dist(7, 2) = 5

=============================================================================
