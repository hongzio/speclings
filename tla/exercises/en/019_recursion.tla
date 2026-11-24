--------------------------- MODULE 019_recursion ----------------------------
EXTENDS Integers
\* speclings tla 019: RECURSIVE
\*
\* A definition cannot use its own name, because a name can only be used
\* below its definition (007). To write a recursive operator, declare it
\* first:
\*
\*   RECURSIVE Fact(_)            one _ per parameter
\*   Fact(n) == IF n = 0 THEN 1 ELSE n * Fact(n - 1)
\*
\* RECURSIVE A(_), B(_, _) declares several at once.
\*
\* There are no loops, so to fold over a set you take one element out
\* with CHOOSE and recurse on the rest, as Sum does below. Write Product
\* the same way (the product of the empty set is 1). Then make TLC
\* accept both.

Sum(S) == IF S = {} THEN 0
          ELSE LET x == CHOOSE y \in S : TRUE
               IN  x + Sum(S \ {x})

Product(S) == ???

ASSUME Sum({}) = 0
ASSUME Sum(1..100) = 5050
ASSUME Product({}) = 1
ASSUME Product({2, 3, 4}) = 24

=============================================================================
