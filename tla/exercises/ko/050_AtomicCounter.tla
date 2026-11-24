------------------------- MODULE 050_AtomicCounter --------------------------
EXTENDS Integers
\* 036 의 원자적 카운터입니다. 050 에서 추상 스펙으로 씁니다.
\* 이 모듈은 고칠 필요가 없습니다.

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
