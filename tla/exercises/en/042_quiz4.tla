----------------------------- MODULE 042_quiz4 ------------------------------
EXTENDS Integers, Sequences
\* tlings 042: quiz
\*
\* Producers send jobs on a channel, and a consumer ranges over it until it
\* is closed. Someone has to close the channel, and closing it too early is
\* a classic bug:
\*
\*   jobs := make(chan string, 1)
\*   for _, p := range producers {
\*       go func() { jobs <- p }()       // send
\*   }
\*   go func() { close(jobs) }()         // close: too early
\*   for j := range jobs {               // recv, until closed and empty
\*       got = append(got, j)
\*   }
\*
\* Sending on a closed channel panics with "send on closed channel". The
\* spec models that as the producer's pc becoming "panic".
\*
\*   1. Write NoPanic, "no producer ever panics", and add it to the .cfg.
\*   2. TLC finds it violated. Fix Close the way Go code does it, with a
\*      WaitGroup: go func() { wg.Wait(); close(jobs) }(). In the spec,
\*      that means Close may only happen once every producer is done.
\*
\*   go run ./tla/go/042_close
\*   go run ./tla/go/042_close -fix

CONSTANT Producers

Cap == 1

VARIABLES ch, closed, pc, consumer, got

vars == <<ch, closed, pc, consumer, got>>

Init == /\ ch = <<>>
        /\ closed = FALSE
        /\ pc = [p \in Producers |-> "send"]
        /\ consumer = "recv"
        /\ got = {}

Send(p) == /\ pc[p] = "send"
           /\ IF closed
                 THEN /\ pc' = [pc EXCEPT ![p] = "panic"]
                      /\ UNCHANGED ch
                 ELSE /\ Len(ch) < Cap
                      /\ ch' = Append(ch, p)
                      /\ pc' = [pc EXCEPT ![p] = "done"]
           /\ UNCHANGED <<closed, consumer, got>>

Close == /\ ~closed
         /\ closed' = TRUE
         /\ UNCHANGED <<ch, pc, consumer, got>>

Recv == /\ consumer = "recv"
        /\ ch # <<>>
        /\ got' = got \cup {Head(ch)}
        /\ ch' = Tail(ch)
        /\ UNCHANGED <<closed, pc, consumer>>

\* range stops once the channel is closed and empty
RangeEnds == /\ consumer = "recv"
             /\ ch = <<>>
             /\ closed
             /\ consumer' = "done"
             /\ UNCHANGED <<ch, closed, pc, got>>

Terminating == /\ consumer = "done"
               /\ \A p \in Producers : pc[p] \in {"done", "panic"}
               /\ UNCHANGED vars

Next == \/ \E p \in Producers : Send(p)
        \/ Close
        \/ Recv
        \/ RangeEnds
        \/ Terminating

Spec == Init /\ [][Next]_vars

NoPanic == ???

\* once the consumer is done, it has received every job
AllReceived == consumer = "done" => got = Producers

=============================================================================
