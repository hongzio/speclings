--------------------------- MODULE 025_evaluation ---------------------------
EXTENDS Integers
\* speclings tla 025: how TLC evaluates Init and Next
\*
\* In math, A /\ B and B /\ A mean the same. But TLC has to compute
\* states, not just check formulas. It reads a conjunction from left to
\* right, and for a variable that has no value yet:
\*
\*   x' = e  or  x' \in S    gives x' its possible values
\*   anything else           is an error: TLC cannot evaluate x' yet
\*
\* Once x' has a value, x' = e and x' \in S are ordinary checks. Init works
\* the same way, with x instead of x'. The error looks like this:
\*
\*   In evaluation, the identifier x is either undefined or not an operator.
\*
\* So put the conjunct that generates a variable's values before the ones
\* that test them. Init and Next below are mathematically right, but TLC
\* cannot evaluate them. Reorder their conjuncts.
\*
\* x starts at any even number from 0 to 8. Each step moves x to a number
\* from 0 to 8 that is at most 2 away.

VARIABLE x

Init == /\ x \in 0..8
        /\ x % 2 = 0

Next == /\ x' \in 0..8
        /\ x' - x \in -2..2

=============================================================================
