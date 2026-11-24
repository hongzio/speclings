----------------------------- MODULE 036_atomic -----------------------------
EXTENDS Integers, FiniteSets
\* speclings tla 036: 원자적 step
\*
\* lock 없이 고치는 방법도 있습니다.
\*
\*   atomic.AddInt64(&counter, 1)    // incr
\*                                   // done
\*
\* 이제 읽기와 쓰기가 쪼갤 수 없는 한 step 에서 일어납니다. TLA+ 에서는
\* 모든 action 이 쪼갤 수 없습니다. 현재 상태와 다음 상태 사이에 다른 일은
\* 일어나지 않습니다. 그래서 원자적 연산은 action 하나이고, counter++ 는
\* 두 개였습니다.
\*
\* 이것이 동시성 스펙에서 가장 중요한 모델링 결정입니다. 코드에서 정말로
\* 원자적인 step 마다 action 하나. action 이 너무 적으면 실제로 있는 race 를
\* TLC 가 못 보고, 너무 많으면 일어날 수 없는 race 를 보고합니다.
\*
\* 원자적 증가 Incr(w) 를 action 하나로 쓰세요.
\*
\* 다 풀었다면: go run -race ./tla/go/034_lost_update -fix atomic

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
