------------------------- MODULE 050_AtomicCounter --------------------------
EXTENDS Integers
\* The atomic counter from 036, used as the abstract spec in exercise 050.
\* You do not need to change this module.

CONSTANT Workers

VARIABLES counter, pc

vars == <<counter, pc>>

Init == /\ counter = 0
        /\ pc = [w \in Workers |-> "incr"]

Incr(w) == /\ pc[w] = "incr"
           /\ counter' = counter + 1
           /\ pc' = [pc EXCEPT ![w] = "done"]

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == \/ \E w \in Workers : Incr(w)
        \/ Terminating

Spec == Init /\ [][Next]_vars

=============================================================================
