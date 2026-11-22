-------------------------- MODULE 034_lost_update ---------------------------
EXTENDS Integers, FiniteSets
\* tlings 034: goroutine 둘, counter 하나
\*
\* 이제 goroutine 두 개가 동시에 incr 를 실행합니다.
\*
\*   go incr()
\*   go incr()
\*
\* incr 는 여전히 읽기와 쓰기 두 step 이고 (Go 의 counter++ 도 마찬가지),
\* 스케줄러는 그 사이에 goroutine 을 바꿀 수 있습니다.
\*
\* goroutine 마다 자기 위치와 자기 tmp 가 있으므로, pc 와 tmp 는
\* goroutine 에서 값으로 가는 함수가 됩니다. pc[w] 는 goroutine w 의
\* 위치입니다. step 하나는 goroutine 하나가 한 줄을 실행하는 것입니다.
\*
\*   Next == \/ \E w \in Workers : Read(w) \/ Write(w)
\*           \/ Terminating
\*
\* TLC 는 두 goroutine 의 모든 interleaving 을 시도합니다.
\*
\* Write(w) 를 쓰세요: w 는 앞서 읽은 값 tmp[w] 에 1 을 더해 씁니다. 그러면
\* TLC 가 Correct 위반을 찾아야 하고, 찾으면 tlings 가 통과시킵니다.
\* trace 를 읽어 보세요. 갱신 유실(lost update)이 한 step 씩 보입니다.
\*
\* 그다음 Go 에서 직접 확인하세요.
\*
\*   go run ./go/034_lost_update          잃어버린 갱신 횟수
\*   go run -race ./go/034_lost_update    race detector 가 잡아냄

CONSTANT Workers

VARIABLES counter, tmp, pc

vars == <<counter, tmp, pc>>

Init == /\ counter = 0
        /\ tmp = [w \in Workers |-> 0]
        /\ pc = [w \in Workers |-> "read"]

Read(w) == /\ pc[w] = "read"
           /\ tmp' = [tmp EXCEPT ![w] = counter]
           /\ pc' = [pc EXCEPT ![w] = "write"]
           /\ UNCHANGED counter

Write(w) == ???

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == \/ \E w \in Workers : Read(w) \/ Write(w)
        \/ Terminating

Spec == Init /\ [][Next]_vars

\* 모든 goroutine 이 return 한 뒤에는 잃어버린 증가가 없다
Correct == (\A w \in Workers : pc[w] = "done") => counter = Cardinality(Workers)

=============================================================================
