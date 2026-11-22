--------------------------- MODULE 021_variables ----------------------------
EXTENDS Integers
\* tlings 021: variables, Init and Next
\*
\* Until now every name stood for a fixed value. From here on, a spec
\* describes a system that changes:
\*
\*   VARIABLE hour    hour can have a different value in each state
\*   Init             a formula about one state: the possible first states
\*   Next             a formula about two states, the current one and the
\*                    next one. hour is the current value and hour' (hour
\*                    prime) is the value in the next state
\*
\* Next is a formula, not an assignment: hour' = hour + 1 is TRUE for the
\* pairs of states in which the next hour is one more than the current one.
\* TLC starts from every state that satisfies Init, takes every step that
\* satisfies Next, and goes on until it has seen every reachable state.
\*
\* The .cfg file tells TLC which formula is which. Have a look at it.
\*
\* This clock shows the hours 0, 1, ..., 11 and then 0 again. Write Next.
\* From now on tlings also checks how many distinct states TLC finds: the
\* clock has exactly 12.

VARIABLE hour

Init == hour = 0

Next == hour' = (hour + 1) % 12

=============================================================================
