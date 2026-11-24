---------------------------- MODULE 041_symmetry ----------------------------
EXTENDS Integers, FiniteSets, TLC
\* speclings tla 041: symmetry
\*
\* With three workers, the mutex counter from 035 has 61 distinct states.
\* Many of them are the same situation with the workers renamed: "w1
\* holds the lock" and "w2 holds the lock" behave alike, because nothing
\* in the spec treats w1 differently from w2.
\*
\* TLC can use that. Declare the permutations of the workers as a symmetry
\* set, and TLC keeps one state from each group of renamed states:
\*
\*   Symm == Permutations(Workers)     Permutations is in the TLC module
\*   SYMMETRY Symm                     in the .cfg
\*
\* This works because the workers are model values, which have no meaning
\* beyond their identity. The state count drops from 61 to 13, and the
\* saving grows fast with more workers. Symmetry is safe for invariants
\* like Correct. For the liveness properties of Part 4 it can hide bugs,
\* so do not use it there.
\*
\* Define Symm and add the symmetry to the .cfg.

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

Correct == (\A w \in Workers : pc[w] = "done") => counter = Cardinality(Workers)

Symm == ???

=============================================================================
