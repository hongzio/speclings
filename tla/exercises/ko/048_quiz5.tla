----------------------------- MODULE 048_quiz5 ------------------------------
\* speclings tla 048: 퀴즈
\*
\* goroutine 두 개가 각자 mutex 두 개, a 와 b 가 필요합니다. deadlock 을
\* 피하려고 첫 번째를 잡고, 두 번째는 TryLock 으로 시도하고, 이미 잡혀
\* 있으면 첫 번째를 놓고 처음부터 다시 합니다.
\*
\*   for {
\*       first.Lock()                // first
\*       if second.TryLock() {       // second
\*           break
\*       }
\*       first.Unlock()              // 물러났다가 다시 시도
\*   }
\*   work()                          // work, 그다음 둘 다 푼다
\*                                   // done
\*
\* w1 은 a 다음 b, w2 는 b 다음 a 를 잡습니다. deadlock 은 없지만 livelock
\* 은 있을 수 있습니다. 둘 다 계속 step 을 밟고 물러나기를 영원히 반복하며
\* 어느 쪽도 끝나지 않습니다.
\*
\*   1. Termination, "결국 모든 goroutine 이 끝난다" 를 쓰고 .cfg 에 속성으로
\*      추가하세요.
\*   2. TLC 가 위반을 찾습니다. 반례의 고리를 읽어 보세요.
\*   3. 표준적인 방법으로 고치세요. 모든 goroutine 이 같은 순서, a 다음 b
\*      로 mutex 를 잡습니다. First 와 Second 를 바꾸세요.

CONSTANT NoOne

Workers == {"w1", "w2"}
Locks == {"a", "b"}

\* 각 goroutine 이 먼저 잡는 mutex 와 두 번째로 시도하는 mutex
First == [w \in Workers |-> IF w = "w1" THEN "a" ELSE "b"]
Second == [w \in Workers |-> IF w = "w1" THEN "b" ELSE "a"]

VARIABLES pc, owner    \* owner[l]: mutex l 을 쥔 goroutine, 또는 NoOne

vars == <<pc, owner>>

Init == /\ pc = [w \in Workers |-> "first"]
        /\ owner = [l \in Locks |-> NoOne]

LockFirst(w) == /\ pc[w] = "first"
                /\ owner[First[w]] = NoOne
                /\ owner' = [owner EXCEPT ![First[w]] = w]
                /\ pc' = [pc EXCEPT ![w] = "second"]

TrySecond(w) == /\ pc[w] = "second"
                /\ IF owner[Second[w]] = NoOne
                      THEN /\ owner' = [owner EXCEPT ![Second[w]] = w]
                           /\ pc' = [pc EXCEPT ![w] = "work"]
                      ELSE /\ owner' = [owner EXCEPT ![First[w]] = NoOne]
                           /\ pc' = [pc EXCEPT ![w] = "first"]

Finish(w) == /\ pc[w] = "work"
             /\ owner' = [l \in Locks |-> IF owner[l] = w THEN NoOne ELSE owner[l]]
             /\ pc' = [pc EXCEPT ![w] = "done"]

Step(w) == LockFirst(w) \/ TrySecond(w) \/ Finish(w)

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == (\E w \in Workers : Step(w)) \/ Terminating

Spec == Init /\ [][Next]_vars /\ \A w \in Workers : WF_vars(Step(w))

Termination == ???

=============================================================================
