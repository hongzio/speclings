----------------------------- MODULE 053_quiz6 ------------------------------
\* tlings 053: quiz
\*
\* Two-phase commit: a transaction manager (TM) and several resource
\* managers (RMs), say services that must all apply a change or all drop
\* it.
\*
\*   phase 1: each RM either prepares (promises it can commit) or refuses
\*   phase 2: the TM commits, and the prepared RMs commit; or the TM
\*            aborts, and every RM that has not committed aborts
\*
\* The TM may only commit once every RM has prepared. This TM commits as
\* soon as any RM has prepared.
\*
\*   1. Write Consistent, "no RM has committed while another has aborted",
\*      and add it to the .cfg as an invariant.
\*   2. TLC finds it violated. Read the trace.
\*   3. Fix TMCommit.

CONSTANT RMs

VARIABLES rmState, tmState

vars == <<rmState, tmState>>

Init == /\ rmState = [r \in RMs |-> "working"]
        /\ tmState = "init"

Prepare(r) == /\ rmState[r] = "working"
              /\ rmState' = [rmState EXCEPT ![r] = "prepared"]
              /\ UNCHANGED tmState

Refuse(r) == /\ rmState[r] = "working"
             /\ rmState' = [rmState EXCEPT ![r] = "aborted"]
             /\ UNCHANGED tmState

TMCommit == /\ tmState = "init"
            /\ \E r \in RMs : rmState[r] = "prepared"
            /\ tmState' = "committed"
            /\ UNCHANGED rmState

TMAbort == /\ tmState = "init"
           /\ tmState' = "aborted"
           /\ UNCHANGED rmState

Commit(r) == /\ tmState = "committed"
             /\ rmState[r] = "prepared"
             /\ rmState' = [rmState EXCEPT ![r] = "committed"]
             /\ UNCHANGED tmState

Abort(r) == /\ tmState = "aborted"
            /\ rmState[r] \in {"working", "prepared"}
            /\ rmState' = [rmState EXCEPT ![r] = "aborted"]
            /\ UNCHANGED tmState

Terminating == /\ tmState # "init"
               /\ \A r \in RMs : rmState[r] \in {"committed", "aborted"}
               /\ UNCHANGED vars

Next == \/ TMCommit \/ TMAbort \/ Terminating
        \/ \E r \in RMs : Prepare(r) \/ Refuse(r) \/ Commit(r) \/ Abort(r)

Spec == Init /\ [][Next]_vars

Consistent == ???

=============================================================================
