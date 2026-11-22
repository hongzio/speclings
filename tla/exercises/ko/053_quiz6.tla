----------------------------- MODULE 053_quiz6 ------------------------------
\* tlings 053: 퀴즈
\*
\* 2 단계 커밋(two-phase commit): 트랜잭션 관리자(TM)와 여러 자원
\* 관리자(RM)가 있습니다. 예를 들어 변경을 모두 적용하거나 모두 버려야 하는
\* 서비스들입니다.
\*
\*   1 단계: 각 RM 은 준비하거나(커밋할 수 있다고 약속) 거절한다
\*   2 단계: TM 이 커밋하면 준비된 RM 들이 커밋한다. 또는 TM 이 중단하면
\*           아직 커밋하지 않은 모든 RM 이 중단한다
\*
\* TM 은 모든 RM 이 준비된 뒤에만 커밋할 수 있습니다. 이 TM 은 어느 RM 이든
\* 하나가 준비되자마자 커밋합니다.
\*
\*   1. Consistent, "어떤 RM 이 커밋했는데 다른 RM 이 중단한 일은 없다" 를
\*      쓰고 .cfg 에 불변식으로 추가하세요.
\*   2. TLC 가 위반을 찾습니다. trace 를 읽어 보세요.
\*   3. TMCommit 을 고치세요.

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
