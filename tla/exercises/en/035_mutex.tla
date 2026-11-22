----------------------------- MODULE 035_mutex ------------------------------
EXTENDS Integers, FiniteSets
\* tlings 035: a mutex
\*
\* The usual fix is a mutex:
\*
\*   mu.Lock()            // lock
\*   tmp := counter       // read
\*   counter = tmp + 1    // write
\*   mu.Unlock()          // unlock
\*                        // done
\*
\* A mutex is just a variable: lock is the goroutine holding it, or NoOne.
\* Lock(w) is only possible while lock = NoOne. That guard is what makes
\* the other goroutine wait: as long as it is FALSE, its Lock action is not
\* enabled, and that is all "blocked" means in a spec.
\*
\* NoOne is a model value, set in the .cfg with NoOne = NoOne. It is a
\* value different from every worker.
\*
\* Write Lock(w) and Unlock(w). Correct must hold now.
\*
\* Afterwards: go run -race ./go/034_lost_update -fix mutex

CONSTANTS Workers, NoOne

VARIABLES counter, tmp, pc, lock

vars == <<counter, tmp, pc, lock>>

Init == /\ counter = 0
        /\ tmp = [w \in Workers |-> 0]
        /\ pc = [w \in Workers |-> "lock"]
        /\ lock = NoOne

Lock(w) == ???

Read(w) == /\ pc[w] = "read"
           /\ tmp' = [tmp EXCEPT ![w] = counter]
           /\ pc' = [pc EXCEPT ![w] = "write"]
           /\ UNCHANGED <<counter, lock>>

Write(w) == /\ pc[w] = "write"
            /\ counter' = tmp[w] + 1
            /\ pc' = [pc EXCEPT ![w] = "unlock"]
            /\ UNCHANGED <<tmp, lock>>

Unlock(w) == ???

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == \/ \E w \in Workers : Lock(w) \/ Read(w) \/ Write(w) \/ Unlock(w)
        \/ Terminating

Spec == Init /\ [][Next]_vars

Correct == (\A w \in Workers : pc[w] = "done") => counter = Cardinality(Workers)

=============================================================================
