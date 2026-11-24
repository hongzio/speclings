--------------------------- MODULE 050_refinement ---------------------------
EXTENDS Integers
\* speclings tla 050: refinement
\*
\* The atomic counter of 036 is the simplest correct description of "each
\* goroutine adds 1 once". The mutex counter of 035 has more steps and more
\* variables. Does it correctly implement the atomic one?
\*
\* Refinement makes that question precise: every behavior of the mutex
\* counter, seen through a refinement mapping, must be a behavior of the
\* atomic counter. The mapping computes the abstract variables from the
\* concrete ones:
\*
\*   Atomic == INSTANCE 050_AtomicCounter WITH pc <- AtomicPc
\*
\* INSTANCE brings in the definitions of another module, with each of its
\* variables and constants replaced by an expression. counter and Workers
\* have the same names here, so they map to themselves. Only pc needs a
\* mapping, because the atomic counter's pc has just two values, "incr" and
\* "done". Atomic!Spec is then the atomic spec in terms of this module's
\* variables, and the .cfg checks it as a property. 050_AtomicCounter.tla
\* is next to this file.
\*
\* Write AtomicPc. Ask yourself when, in the mutex counter, the abstract
\* increment happens: at which step does counter change?
\*
\* (The racy counter of 034 fails this check with the same mapping: a lost
\* update is a step that no atomic increment can explain.)

CONSTANTS Workers, NoOne

VARIABLES counter, tmp, pc, lock

vars == <<counter, tmp, pc, lock>>

Init == /\ counter = 0
        /\ tmp = [w \in Workers |-> 0]
        /\ pc = [w \in Workers |-> "lock"]
        /\ lock = NoOne

Lock(w) == /\ pc[w] = "lock"
           /\ lock = NoOne
           /\ lock' = w
           /\ pc' = [pc EXCEPT ![w] = "read"]
           /\ UNCHANGED <<counter, tmp>>

Read(w) == /\ pc[w] = "read"
           /\ tmp' = [tmp EXCEPT ![w] = counter]
           /\ pc' = [pc EXCEPT ![w] = "write"]
           /\ UNCHANGED <<counter, lock>>

Write(w) == /\ pc[w] = "write"
            /\ counter' = tmp[w] + 1
            /\ pc' = [pc EXCEPT ![w] = "unlock"]
            /\ UNCHANGED <<tmp, lock>>

Unlock(w) == /\ pc[w] = "unlock"
             /\ lock' = NoOne
             /\ pc' = [pc EXCEPT ![w] = "done"]
             /\ UNCHANGED <<counter, tmp>>

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == \/ \E w \in Workers : Lock(w) \/ Read(w) \/ Write(w) \/ Unlock(w)
        \/ Terminating

Spec == Init /\ [][Next]_vars

\* the atomic counter's pc: "incr" before w's increment, "done" after it
AtomicPc == [w \in Workers |-> IF pc[w] \in {"unlock", "done"} THEN "done" ELSE "incr"]

Atomic == INSTANCE 050_AtomicCounter WITH pc <- AtomicPc

AtomicSpec == Atomic!Spec

=============================================================================
