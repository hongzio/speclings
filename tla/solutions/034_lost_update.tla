-------------------------- MODULE 034_lost_update ---------------------------
EXTENDS Integers, FiniteSets
\* tlings 034: two goroutines, one counter
\*
\* Now two goroutines run incr at the same time:
\*
\*   go incr()
\*   go incr()
\*
\* incr is still two steps, a read and a write (counter++ in Go is the
\* same), and the scheduler may switch goroutines between them.
\*
\* Each goroutine has its own position and its own tmp, so pc and tmp
\* become functions from goroutines to values: pc[w] is where goroutine w
\* is. A step is one goroutine executing one line:
\*
\*   Next == \/ \E w \in Workers : Read(w) \/ Write(w)
\*           \/ Terminating
\*
\* TLC tries every interleaving of the two goroutines.
\*
\* Write Write(w): w writes tmp[w] + 1, the value it read earlier. TLC
\* should then find Correct violated, and tlings passes when it does. Read
\* the trace: it is a lost update, step by step.
\*
\* Then watch it happen in Go:
\*
\*   go run ./tla/go/034_lost_update          lost updates, counted
\*   go run -race ./tla/go/034_lost_update    the race detector reports it

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

Write(w) == /\ pc[w] = "write"
            /\ counter' = tmp[w] + 1
            /\ pc' = [pc EXCEPT ![w] = "done"]
            /\ UNCHANGED tmp

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == \/ \E w \in Workers : Read(w) \/ Write(w)
        \/ Terminating

Spec == Init /\ [][Next]_vars

\* once every goroutine has returned, no increment is lost
Correct == (\A w \in Workers : pc[w] = "done") => counter = Cardinality(Workers)

=============================================================================
