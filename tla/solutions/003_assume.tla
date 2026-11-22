----------------------------- MODULE 003_assume -----------------------------
EXTENDS Naturals
\* tlings 003: ASSUME
\*
\* ASSUME P declares "we assume P is true". Before exploring any states,
\* TLC evaluates every ASSUME. If one is false, TLC stops and tells you
\* where it is:
\*
\*   Error: Assumption line N, col M to ... of module 003_assume is false.
\*
\* tlings uses ASSUME like an assert in a unit test. Most exercises in
\* Part 1 (004 onward) ask you to make every ASSUME true.
\*
\* Here = is not assignment. It asks "are these equal?", like == in Go,
\* so Two = 2 evaluates to either TRUE or FALSE. TLA+ has no assignment
\* at all, and that fact becomes important again in Part 2.
\*
\* One of the ASSUMEs below is false. Use the line number in TLC's error
\* message to find it, then fix it. Leave the expression on the left
\* alone and change the value on the right.

Two == 1 + 1

ASSUME Two = 2
ASSUME Two + Two = 4
ASSUME Two * Two = 4
ASSUME Two * Two * Two = 8
ASSUME Two < 3

=============================================================================
