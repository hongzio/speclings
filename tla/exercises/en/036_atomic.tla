----------------------------- MODULE 036_atomic -----------------------------
EXTENDS Integers, FiniteSets
\* speclings tla 036: atomic steps
\*
\* Another fix needs no lock at all:
\*
\*   atomic.AddInt64(&counter, 1)    // incr
\*                                   // done
\*
\* The read and the write now happen as one indivisible step. In TLA+,
\* every action is indivisible: nothing else happens between the current
\* state and the next one. So an atomic operation is one action, where
\* counter++ was two.
\*
\* This is the key modeling decision in a concurrent spec: one action for
\* each step that really is atomic in the code. Too few actions, and TLC
\* cannot see races that exist; too many, and it reports races that
\* cannot happen.
\*
\* Write Incr(w), the atomic increment, as one action.
\*
\* Afterwards: go run -race ./tla/go/034_lost_update -fix atomic

CONSTANT Workers

VARIABLES counter, pc

vars == <<counter, pc>>

Init == /\ counter = 0
        /\ pc = [w \in Workers |-> "incr"]

Incr(w) == ???

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == \/ \E w \in Workers : Incr(w)
        \/ Terminating

Spec == Init /\ [][Next]_vars

Correct == (\A w \in Workers : pc[w] = "done") => counter = Cardinality(Workers)

=============================================================================
