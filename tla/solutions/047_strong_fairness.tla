------------------------ MODULE 047_strong_fairness -------------------------
\* speclings tla 047: strong fairness
\*
\* Two goroutines loop forever: lock the mutex, work, unlock, and lock
\* again. NoStarvation says that a goroutine waiting for the lock
\* eventually gets it. Spec gives each goroutine weak fairness, yet TLC
\* finds NoStarvation violated.
\*
\* WF only helps an action that stays enabled, and Lock(w2) does not: it is
\* enabled while the mutex is free and disabled again as soon as w1 takes
\* it. If w1 always wins, w2 waits forever, and weak fairness is still
\* satisfied.
\*
\*   SF_vars(A)    strong fairness: if A is enabled again and again
\*                 (infinitely often), A eventually happens
\*
\* Give Lock(w) strong fairness instead. (Go's sync.Mutex switches to a
\* "starvation mode" once a goroutine has waited more than 1ms, which in
\* practice gives you something like strong fairness.)

CONSTANTS Workers, NoOne

VARIABLES pc, lock

vars == <<pc, lock>>

Init == /\ pc = [w \in Workers |-> "lock"]
        /\ lock = NoOne

Lock(w) == /\ pc[w] = "lock"
           /\ lock = NoOne
           /\ lock' = w
           /\ pc' = [pc EXCEPT ![w] = "work"]

Unlock(w) == /\ pc[w] = "work"
             /\ lock' = NoOne
             /\ pc' = [pc EXCEPT ![w] = "lock"]

Next == \E w \in Workers : Lock(w) \/ Unlock(w)

Spec == /\ Init
        /\ [][Next]_vars
        /\ \A w \in Workers : SF_vars(Lock(w)) /\ WF_vars(Unlock(w))

NoStarvation == \A w \in Workers : (pc[w] = "lock") ~> (pc[w] = "work")

=============================================================================
