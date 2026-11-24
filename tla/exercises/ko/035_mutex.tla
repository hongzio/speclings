----------------------------- MODULE 035_mutex ------------------------------
EXTENDS Integers, FiniteSets
\* tlings 035: mutex
\*
\* 흔한 해결책은 mutex 입니다.
\*
\*   mu.Lock()            // lock
\*   tmp := counter       // read
\*   counter = tmp + 1    // write
\*   mu.Unlock()          // unlock
\*                        // done
\*
\* mutex 도 그냥 변수입니다. lock 은 mutex 를 쥔 goroutine 이거나 NoOne
\* 입니다. Lock(w) 는 lock = NoOne 일 때만 가능합니다. 이 guard 가 다른
\* goroutine 을 기다리게 합니다. FALSE 인 동안 그쪽의 Lock action 은 가능하지
\* 않고, 스펙에서 "막혔다(blocked)" 는 바로 그 뜻입니다.
\*
\* NoOne 은 .cfg 에서 NoOne = NoOne 으로 정하는 model value 입니다. 어떤
\* worker 와도 다른 값입니다.
\*
\* Lock(w) 와 Unlock(w) 를 쓰세요. 이제 Correct 가 성립해야 합니다.
\*
\* 다 풀었다면: go run -race ./tla/go/034_lost_update -fix mutex

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
