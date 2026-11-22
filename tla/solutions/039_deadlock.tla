---------------------------- MODULE 039_deadlock ----------------------------
\* tlings 039: unbuffered channels and deadlock
\*
\* An unbuffered channel has no room at all: a send and a receive happen
\* together, as one step, when both goroutines are ready. In TLA+ that is a
\* single action that moves both goroutines at once.
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
\* Main waits for b before it sends on a, and the worker waits for a
\* before it sends on b. Go stops this program with
\*
\*   fatal error: all goroutines are asleep - deadlock!
\*
\* which is exactly a deadlock in TLA+: a state with no enabled action.
\*
\* Write SyncA and SyncB, the two rendezvous: each happens only when one
\* goroutine is about to send and the other about to receive, and moves
\* both on. TLC should then report the deadlock, and tlings passes when it
\* does.
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

\* main sends on a, the worker receives
SyncA == /\ mainPc = "sendA"
         /\ workerPc = "recvA"
         /\ mainPc' = "done"
         /\ workerPc' = "sendB"

\* the worker sends on b, main receives
SyncB == /\ workerPc = "sendB"
         /\ mainPc = "recvB"
         /\ workerPc' = "done"
         /\ mainPc' = "sendA"

Terminating == /\ mainPc = "done"
               /\ workerPc = "done"
               /\ UNCHANGED vars

Next == MainStart \/ WorkerStart \/ SyncA \/ SyncB \/ Terminating

Spec == Init /\ [][Next]_vars

=============================================================================
