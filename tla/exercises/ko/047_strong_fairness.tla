------------------------ MODULE 047_strong_fairness -------------------------
\* tlings 047: 강한 공정성
\*
\* goroutine 두 개가 영원히 돕니다: mutex 를 잡고, 일하고, 풀고, 다시
\* 잡습니다. NoStarvation 은 lock 을 기다리는 goroutine 이 결국 lock 을
\* 얻는다는 뜻입니다. Spec 은 각 goroutine 에 약한 공정성을 주는데도 TLC
\* 가 NoStarvation 위반을 찾습니다.
\*
\* WF 는 계속 가능한 상태로 남는 action 만 돕는데, Lock(w2) 는 그렇지
\* 않습니다. mutex 가 비어 있는 동안 가능했다가, w1 이 잡자마자 다시
\* 불가능해집니다. w1 이 매번 이기면 w2 는 영원히 기다리고, 그래도 약한
\* 공정성은 만족됩니다.
\*
\*   SF_vars(A)    강한 공정성: A 가 계속해서 (무한히 자주) 가능해지면,
\*                 A 는 결국 일어난다
\*
\* Lock(w) 에 강한 공정성을 주세요. (Go 의 sync.Mutex 는 goroutine 이 1ms
\* 넘게 기다리면 "starvation mode" 로 바뀌는데, 실제로는 강한 공정성과
\* 비슷한 효과를 냅니다.)

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
        /\ \A w \in Workers : WF_vars(Lock(w)) /\ WF_vars(Unlock(w))

NoStarvation == \A w \in Workers : (pc[w] = "lock") ~> (pc[w] = "work")

=============================================================================
