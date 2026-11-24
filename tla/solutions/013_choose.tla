----------------------------- MODULE 013_choose -----------------------------
EXTENDS Integers
\* tlings 013: CHOOSE
\*
\*   CHOOSE x \in S : P    an element x of S for which P holds
\*
\* CHOOSE is not random. For the same S and P it always gives the same
\* element, so (CHOOSE x \in S : P) = (CHOOSE x \in S : P) is always TRUE.
\* Which element, TLA+ does not say, so never rely on it. If no element
\* satisfies P, TLC reports an error.
\*
\* CHOOSE is most useful when exactly one element satisfies P: it defines
\* "the x such that P". To model an arbitrary choice, such as which
\* goroutine runs next, you will use \E in Part 2, not CHOOSE.

\* the largest element of S
Max(S) == CHOOSE x \in S : \A y \in S : x >= y

ASSUME Max({3, 9, 4}) = 9
ASSUME Max({-1}) = -1
\* TRUE or FALSE?
ASSUME ((CHOOSE x \in 1..10 : x > 3) = (CHOOSE x \in 1..10 : x > 3)) = TRUE

=============================================================================
