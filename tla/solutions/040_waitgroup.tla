--------------------------- MODULE 040_waitgroup ----------------------------
EXTENDS Integers, FiniteSets
\* tlings 040: WaitGroup
\*
\* A classic mistake: calling wg.Add inside the goroutine.
\*
\*   var wg sync.WaitGroup
\*   for range workers {               // main: spawn
\*       go func() {                   // worker: idle until spawned
\*           wg.Add(1)                 // add
\*           defer wg.Done()           // work, then done
\*           work()
\*       }()
\*   }
\*   wg.Wait()                         // main: wait
\*   fmt.Println("all done")           // main: after
\*
\* A WaitGroup is a counter: Add increases it, Done decreases it, and Wait
\* blocks until it is 0. Here main can reach Wait before any goroutine has
\* called Add, see 0 and go on at once. TLC finds AllWorkDone violated.
\* (go vet catches this mistake when wg.Add is written directly inside the
\* goroutine, but not in every form.)
\*
\* Fix the spec the way the Go code should be fixed: main calls
\* wg.Add(len(workers)) before starting the goroutines, which no longer
\* call Add. In the spec:
\*
\*   - add an action MainAdd that sets wg to the number of workers and
\*     moves main from "add" to "spawn"; main now starts at "add"
\*   - Spawn starts the workers at "work"
\*   - remove Add(w)
\*
\*   go run ./go/040_waitgroup
\*   go run ./go/040_waitgroup -fix

CONSTANT Workers

VARIABLES wg, pc, mainPc

vars == <<wg, pc, mainPc>>

Init == /\ wg = 0
        /\ pc = [w \in Workers |-> "idle"]
        /\ mainPc = "add"

MainAdd == /\ mainPc = "add"
           /\ wg' = Cardinality(Workers)
           /\ mainPc' = "spawn"
           /\ UNCHANGED pc

Spawn == /\ mainPc = "spawn"
         /\ pc' = [w \in Workers |-> "work"]
         /\ mainPc' = "wait"
         /\ UNCHANGED wg

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

Next == \/ MainAdd
        \/ Spawn
        \/ \E w \in Workers : Done(w)
        \/ Wait
        \/ Terminating

Spec == Init /\ [][Next]_vars

\* once main is past Wait, every worker has finished
AllWorkDone == mainPc = "after" => \A w \in Workers : pc[w] = "done"

=============================================================================
