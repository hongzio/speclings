---------------------------- MODULE 039_deadlock ----------------------------
EXTENDS Integers, Sequences
\* speclings tla 039: 버퍼 없는 채널과 deadlock
\*
\* 버퍼 없는 채널에는 자리가 전혀 없습니다. 보내기와 받기는 두 goroutine 이
\* 모두 준비됐을 때 한 step 으로 함께 일어납니다. TLA+ 에서는 두
\* goroutine 을 한꺼번에 움직이는 action 하나입니다.
\*
\*   a, b := make(chan int), make(chan int)
\*   go func() {      // worker
\*       <-a          // 1: recvA
\*       b <- 1       // 2: sendB
\*       <-a          // 3: recvA
\*       b <- 2       // 4: sendB
\*   }()
\*   a <- 1           // main 1: sendA
\*   <-b              // main 2: recvB
\*   <-b              // main 3: recvB (a 로 먼저 보내야 함)
\*   a <- 2           // main 4: sendA
\*
\* 첫 번째 주고받기는 잘 됩니다. 그다음 main 은 b 를, worker 는 a 를
\* 기다리고, Go 는 이 프로그램을 이렇게 멈춥니다.
\*
\*   fatal error: all goroutines are asleep - deadlock!
\*
\* 이것은 정확히 TLA+ 의 deadlock, 즉 가능한 action 이 없는 상태입니다.
\*
\* 여기서는 각 goroutine 의 코드를 채널 연산의 시퀀스로 두고, pc 는 다음
\* 연산의 위치입니다. 두 랑데부 SyncA 와 SyncB 를 쓰세요. 각각 한
\* goroutine 의 다음 연산이 보내기이고 다른 쪽의 다음 연산이 짝이 맞는
\* 받기일 때만 일어나며, 두 goroutine 을 모두 다음 연산으로 옮깁니다. 그러면
\* TLC 가 첫 주고받기 뒤의 deadlock 을 보고해야 하고, 보고하면 speclings 가
\* 통과시킵니다.
\*
\*   go run ./tla/go/039_deadlock
\*   go run ./tla/go/039_deadlock -fix

MainCode == <<"sendA", "recvB", "recvB", "sendA">>
WorkerCode == <<"recvA", "sendB", "recvA", "sendB">>

VARIABLES mainPc, workerPc    \* 코드에서 다음 연산의 위치

vars == <<mainPc, workerPc>>

\* 위치 pc 의 연산. 코드 끝을 지나면 "done"
Op(code, pc) == IF pc <= Len(code) THEN code[pc] ELSE "done"

Init == mainPc = 1 /\ workerPc = 1

\* main 이 a 로 보내고, worker 가 받는다
SyncA == ???

\* worker 가 b 로 보내고, main 이 받는다
SyncB == ???

Terminating == /\ Op(MainCode, mainPc) = "done"
               /\ Op(WorkerCode, workerPc) = "done"
               /\ UNCHANGED vars

Next == SyncA \/ SyncB \/ Terminating

Spec == Init /\ [][Next]_vars

=============================================================================
