--------------------------- MODULE 050_refinement ---------------------------
EXTENDS Integers
\* tlings 050: refinement
\*
\* 036 의 원자적 카운터는 "각 goroutine 이 한 번씩 1 을 더한다" 를 가장
\* 단순하고 올바르게 기술한 것입니다. 035 의 mutex 카운터는 step 도 변수도
\* 더 많습니다. mutex 카운터는 원자적 카운터를 올바르게 구현할까요?
\*
\* refinement 는 이 질문을 정확하게 만듭니다. mutex 카운터의 모든 behavior
\* 를 refinement mapping 을 통해 보면 원자적 카운터의 behavior 여야 합니다.
\* mapping 은 구체적인 변수로부터 추상적인 변수를 계산합니다.
\*
\*   Atomic == INSTANCE 050_AtomicCounter WITH pc <- AtomicPc
\*
\* INSTANCE 는 다른 모듈의 정의를 가져오되, 그 모듈의 변수와 상수를 각각
\* 식으로 바꿉니다. counter 와 Workers 는 여기서도 이름이 같아서 자기
\* 자신으로 대응됩니다. 원자적 카운터의 pc 는 "incr" 와 "done" 두 값뿐이라
\* pc 만 mapping 이 필요합니다. 그러면 Atomic!Spec 은 이 모듈의 변수로
\* 나타낸 원자적 스펙이 되고, .cfg 가 이를 속성으로 검사합니다.
\* 050_AtomicCounter.tla 는 이 파일 옆에 있습니다.
\*
\* AtomicPc 를 쓰세요. mutex 카운터에서 추상적인 증가가 언제 일어나는지,
\* 즉 counter 가 어느 step 에서 바뀌는지 생각해 보세요.
\*
\* (034 의 race 있는 카운터는 같은 mapping 으로 이 검사에 실패합니다. 잃어버린
\* 갱신은 어떤 원자적 증가로도 설명할 수 없는 step 이기 때문입니다.)

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

\* 원자적 카운터의 pc: w 의 증가 전에는 "incr", 후에는 "done"
AtomicPc == ???

Atomic == INSTANCE 050_AtomicCounter WITH pc <- AtomicPc

AtomicSpec == Atomic!Spec

=============================================================================
