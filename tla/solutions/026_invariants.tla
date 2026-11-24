--------------------------- MODULE 026_invariants ---------------------------
EXTENDS Integers
\* tlings 026: invariants
\*
\* An invariant is a formula about one state that should be TRUE in every
\* reachable state. You list invariants in the .cfg:
\*
\*   INVARIANT TypeOK
\*
\* TLC checks them in each state it finds. At the first state where one is
\* FALSE, it stops and prints the behavior that leads there: a
\* counterexample.
\*
\* TypeOK is the customary first invariant: every variable holds the kind
\* of value you meant. TLA+ has no types, so this is how you notice that a
\* counter meant to stay in 0..3 reached 4.
\*
\* This parking lot has room for Capacity cars. Write TypeOK, "cars is a
\* number from 0 to Capacity", and add it to the .cfg as an invariant.
\* The spec has a bug, so this time the goal is a violation: tlings passes
\* when TLC reports TypeOK violated, and shows you the counterexample. You
\* do not need to fix the bug: the next exercise is about reading
\* counterexamples like this one and fixing what they show.

Capacity == 3

VARIABLE cars

Init == cars = 0

Enter == /\ cars <= Capacity
         /\ cars' = cars + 1

Leave == /\ cars > 0
         /\ cars' = cars - 1

Next == Enter \/ Leave

TypeOK == cars \in 0..Capacity

=============================================================================
