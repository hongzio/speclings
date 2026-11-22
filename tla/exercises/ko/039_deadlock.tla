---------------------------- MODULE 039_deadlock ----------------------------
\* tlings 039: 버퍼 없는 채널과 deadlock
\*
\* 버퍼 없는 채널에는 자리가 전혀 없습니다. 보내기와 받기는 두 goroutine 이
\* 모두 준비됐을 때 한 step 으로 함께 일어납니다. TLA+ 에서는 두
\* goroutine 을 한꺼번에 움직이는 action 하나입니다.
\*
\*   a, b := make(chan int), make(chan int)
\*   go func() {        // worker: start
\*       <-a            // recvA
\*       b <- 1         // sendB
\*   }()                // done
\*                      // main: start
\*   <-b                // recvB
\*   a <- 1             // sendA
\*                      // done
\*
\* main 은 a 로 보내기 전에 b 를 기다리고, worker 는 b 로 보내기 전에 a 를
\* 기다립니다. Go 는 이 프로그램을 이렇게 멈춥니다.
\*
\*   fatal error: all goroutines are asleep - deadlock!
\*
\* 이것은 정확히 TLA+ 의 deadlock, 즉 가능한 action 이 없는 상태입니다.
\*
\* 두 랑데부 SyncA 와 SyncB 를 쓰세요. 각각 한 goroutine 이 막 보내려 하고
\* 다른 goroutine 이 막 받으려 할 때만 일어나며, 둘 다 다음으로 옮깁니다.
\* 그러면 TLC 가 deadlock 을 보고해야 하고, 보고하면 tlings 가 통과시킵니다.
\*
\*   go run ./go/039_deadlock
\*   go run ./go/039_deadlock -fix

VARIABLES mainPc, workerPc

vars == <<mainPc, workerPc>>

Init == mainPc = "start" /\ workerPc = "start"

MainStart == /\ mainPc = "start"
             /\ mainPc' = "recvB"
             /\ UNCHANGED workerPc

WorkerStart == /\ workerPc = "start"
               /\ workerPc' = "recvA"
               /\ UNCHANGED mainPc

\* main 이 a 로 보내고, worker 가 받는다
SyncA == ???

\* worker 가 b 로 보내고, main 이 받는다
SyncB == ???

Terminating == /\ mainPc = "done"
               /\ workerPc = "done"
               /\ UNCHANGED vars

Next == MainStart \/ WorkerStart \/ SyncA \/ SyncB \/ Terminating

Spec == Init /\ [][Next]_vars

=============================================================================
