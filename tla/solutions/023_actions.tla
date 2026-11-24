---------------------------- MODULE 023_actions -----------------------------
EXTENDS Integers
\* speclings tla 023: actions and \/
\*
\* Next usually allows several kinds of step. Each kind is called an
\* action, and Next is their disjunction:
\*
\*   Next == Open \/ Close \/ Lock \/ Unlock
\*
\* In every state TLC tries every action, so behaviors branch. The spec
\* does not say which step comes next, only which steps are possible. This
\* is how a spec says "any goroutine may run next" or "the user may press
\* any button".
\*
\* A conjunct without primes, like door = "closed" in Open, is a guard:
\* the action can only happen in states where it is TRUE.
\*
\* Write Lock: a closed door that is not locked can be locked. Then add
\* Lock to Next. Without the right guard, TLC reaches a state that should
\* be impossible, an open door that is locked, and the state count is off.

VARIABLES door, locked

Init == door = "closed" /\ locked = FALSE

Open   == /\ door = "closed"
          /\ ~locked
          /\ door' = "open"
          /\ UNCHANGED locked

Close  == /\ door = "open"
          /\ door' = "closed"
          /\ UNCHANGED locked

Lock   == /\ door = "closed"
          /\ ~locked
          /\ locked' = TRUE
          /\ UNCHANGED door

Unlock == /\ locked
          /\ locked' = FALSE
          /\ UNCHANGED door

Next == Open \/ Close \/ Lock \/ Unlock

=============================================================================
