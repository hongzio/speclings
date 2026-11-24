---------------------------- MODULE 039_deadlock ----------------------------
EXTENDS Integers, Sequences
\* speclings tla 039: unbuffered channels and deadlock
\*
\* An unbuffered channel has no room at all: a send and a receive happen
\* together, as one step, when both goroutines are ready. In TLA+ that is a
\* single action that moves both goroutines at once.
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
\*   <-b              // main 3: recvB (should send on a first)
\*   a <- 2           // main 4: sendA
\*
\* The first exchange works. Then main waits for b while the worker waits
\* for a, and Go stops the program with
\*
\*   fatal error: all goroutines are asleep - deadlock!
\*
\* which is exactly a deadlock in TLA+: a state with no enabled action.
\*
\* Here each goroutine's code is a sequence of channel operations, and its
\* pc is the position of its next operation. Write SyncA and SyncB, the two
\* rendezvous: each happens only when one goroutine's next operation is a
\* send and the other's is the matching receive, and it moves both
\* goroutines on to their next operation. TLC should then report the
\* deadlock after the first exchange, and speclings passes when it does.
\*
\*   go run ./tla/go/039_deadlock
\*   go run ./tla/go/039_deadlock -fix

MainCode == <<"sendA", "recvB", "recvB", "sendA">>
WorkerCode == <<"recvA", "sendB", "recvA", "sendB">>

VARIABLES mainPc, workerPc    \* the position of the next operation in the code

vars == <<mainPc, workerPc>>

\* the operation at position pc, or "done" past the end of the code
Op(code, pc) == IF pc <= Len(code) THEN code[pc] ELSE "done"

Init == mainPc = 1 /\ workerPc = 1

\* main sends on a, the worker receives
SyncA == /\ Op(MainCode, mainPc) = "sendA"
         /\ Op(WorkerCode, workerPc) = "recvA"
         /\ mainPc' = mainPc + 1
         /\ workerPc' = workerPc + 1

\* the worker sends on b, main receives
SyncB == /\ Op(WorkerCode, workerPc) = "sendB"
         /\ Op(MainCode, mainPc) = "recvB"
         /\ workerPc' = workerPc + 1
         /\ mainPc' = mainPc + 1

Terminating == /\ Op(MainCode, mainPc) = "done"
               /\ Op(WorkerCode, workerPc) = "done"
               /\ UNCHANGED vars

Next == SyncA \/ SyncB \/ Terminating

Spec == Init /\ [][Next]_vars

=============================================================================
