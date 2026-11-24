--------------------------- MODULE 044_eventually ---------------------------
EXTENDS Integers
\* speclings tla 044: eventually, and fairness
\*
\*   <>P     P holds at some point: "eventually P"
\*
\* <> makes a liveness property: it says that something good eventually
\* happens, not only that nothing bad ever does. The .cfg checks that this
\* download (from 028) eventually finishes, but TLC reports the property
\* violated, with a counterexample that ends in "Stuttering".
\*
\* Spec allows stuttering steps (031), and nothing in it stops a behavior
\* from stuttering forever: the download just stops, and Spec still holds.
\* Real processes keep running, and fairness is how a spec says so:
\*
\*   WF_vars(A)    weak fairness: if A stays enabled forever, A eventually
\*                 happens (as a step that changes vars)
\*
\* For a single process, WF_vars(Next) means "it does not stop while it can
\* still make progress". Add it to Spec as a third conjunct.

VARIABLES received, status

vars == <<received, status>>

Init == received = 0 /\ status = "downloading"

Get == /\ status = "downloading"
       /\ received < 3
       /\ received' = received + 1
       /\ UNCHANGED status

Finish == /\ status = "downloading"
          /\ received = 3
          /\ status' = "done"
          /\ UNCHANGED received

Terminating == /\ status = "done"
               /\ UNCHANGED vars

Next == Get \/ Finish \/ Terminating

Spec == Init /\ [][Next]_vars

EventuallyDone == <>(status = "done")

=============================================================================
