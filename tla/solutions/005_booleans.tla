---------------------------- MODULE 005_booleans ----------------------------
EXTENDS Integers
\* tlings 005: booleans
\*
\* TLA+ has the values TRUE and FALSE (BOOLEAN is the set of both) and:
\*
\*   A /\ B     and                (Go: A && B)
\*   A \/ B     or                 (Go: A || B)
\*   ~A         not                (Go: !A)
\*   a = b      equal              (Go: a == b)
\*   a # b      not equal, also written a /= b    (Go: a != b)
\*   A => B     implies: "if A, then B"
\*   A <=> B    A and B have the same truth value
\*
\* Go has no =>, but specs use it everywhere: "if the account is closed,
\* then its balance is 0". A => B is FALSE only when A is TRUE and B is
\* FALSE. When A is FALSE, A => B is TRUE whatever B is.
\*
\* Use parentheses freely; precedence rules are easy to get wrong.
\*
\* Replace each ??? with TRUE or FALSE.

ASSUME (TRUE /\ FALSE) = FALSE
ASSUME (TRUE \/ FALSE) = TRUE
ASSUME (~TRUE) = FALSE
ASSUME (1 # 2) = TRUE
ASSUME (FALSE => FALSE) = TRUE
ASSUME (TRUE => FALSE) = FALSE
ASSUME ((1 < 2) <=> (3 < 2)) = FALSE

=============================================================================
