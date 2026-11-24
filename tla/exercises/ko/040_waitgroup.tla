--------------------------- MODULE 040_waitgroup ----------------------------
EXTENDS Integers, FiniteSets
\* tlings 040: WaitGroup
\*
\* 흔한 실수: goroutine 안에서 wg.Add 를 부르기.
\*
\*   var wg sync.WaitGroup
\*   for range workers {               // main: spawn
\*       go func() {                   // worker: spawn 전까지 idle
\*           wg.Add(1)                 // add
\*           defer wg.Done()           // work, 그다음 done
\*           work()
\*       }()
\*   }
\*   wg.Wait()                         // main: wait
\*   fmt.Println("all done")           // main: after
\*
\* WaitGroup 은 카운터입니다. Add 는 늘리고, Done 은 줄이고, Wait 는 0 이 될
\* 때까지 막힙니다. 여기서는 어떤 goroutine 도 Add 를 부르기 전에 main 이
\* Wait 에 도착해 0 을 보고 바로 지나갈 수 있습니다. TLC 가 AllWorkDone
\* 위반을 찾습니다. (wg.Add 를 goroutine 안에 직접 쓰면 go vet 이 이 실수를
\* 잡지만, 모든 형태를 잡지는 못합니다.)
\*
\* Go 코드를 고칠 방식대로 스펙을 고치세요. main 이 goroutine 을 시작하기
\* 전에 wg.Add(len(workers)) 를 부르고, goroutine 은 더 이상 Add 를 부르지
\* 않습니다. 스펙에서는:
\*
\*   - wg 를 worker 수로 정하고 main 을 "add" 에서 "spawn" 으로 옮기는
\*     action MainAdd 를 추가한다. main 은 이제 "add" 에서 시작한다
\*   - Spawn 은 worker 를 "work" 에서 시작하게 한다
\*   - Add(w) 를 없앤다
\*
\*   go run ./go/040_waitgroup
\*   go run ./go/040_waitgroup -fix

CONSTANT Workers

VARIABLES wg, pc, mainPc

vars == <<wg, pc, mainPc>>

Init == /\ wg = 0
        /\ pc = [w \in Workers |-> "idle"]
        /\ mainPc = "spawn"

Spawn == /\ mainPc = "spawn"
         /\ pc' = [w \in Workers |-> "add"]
         /\ mainPc' = "wait"
         /\ UNCHANGED wg

Add(w) == /\ pc[w] = "add"
          /\ wg' = wg + 1
          /\ pc' = [pc EXCEPT ![w] = "work"]
          /\ UNCHANGED mainPc

Done(w) == /\ pc[w] = "work"
           /\ wg' = wg - 1
           /\ pc' = [pc EXCEPT ![w] = "done"]
           /\ UNCHANGED mainPc

Wait == /\ mainPc = "wait"
        /\ wg = 0
        /\ mainPc' = "after"
        /\ UNCHANGED <<wg, pc>>

Terminating == /\ mainPc = "after"
               /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == \/ Spawn
        \/ \E w \in Workers : Add(w) \/ Done(w)
        \/ Wait
        \/ Terminating

Spec == Init /\ [][Next]_vars

\* main 이 Wait 를 지나면 모든 worker 가 끝난 상태다
AllWorkDone == mainPc = "after" => \A w \in Workers : pc[w] = "done"

=============================================================================
