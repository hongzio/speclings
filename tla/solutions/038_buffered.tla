---------------------------- MODULE 038_buffered ----------------------------
EXTENDS Integers, Sequences
\* speclings tla 038: buffered channels
\*
\*   ch := make(chan int, 2)
\*   go func() {                       // producer
\*       for i := 1; i <= 3; i++ {
\*           ch <- i                   // send
\*       }
\*   }()
\*   for i := 0; i < 3; i++ {          // consumer
\*       got = append(got, <-ch)       // receive
\*   }
\*
\* A buffered channel is a FIFO queue with a capacity, so a sequence (018).
\* Its blocking rules become guards:
\*
\*   ch <- v    only while Len(ch) < Cap: sending on a full channel blocks
\*   <-ch       only while ch # <<>>: receiving on an empty channel blocks
\*
\* A blocked goroutine is simply one whose next action is not enabled.
\* Here the producer's loop counter sent stands in for its pc, and so does
\* Len(got) for the consumer.
\*
\* Write Send and Recv. TypeOK checks the capacity, and InOrder checks that
\* the values arrive in the order they were sent.

N == 3
Cap == 2

VARIABLES ch, sent, got

vars == <<ch, sent, got>>

Init == /\ ch = <<>>
        /\ sent = 0
        /\ got = <<>>

\* the producer sends sent + 1
Send == /\ sent < N
        /\ Len(ch) < Cap
        /\ ch' = Append(ch, sent + 1)
        /\ sent' = sent + 1
        /\ UNCHANGED got

\* the consumer receives the oldest value
Recv == /\ Len(got) < N
        /\ ch # <<>>
        /\ got' = Append(got, Head(ch))
        /\ ch' = Tail(ch)
        /\ UNCHANGED sent

Terminating == /\ sent = N
               /\ Len(got) = N
               /\ UNCHANGED vars

Next == Send \/ Recv \/ Terminating

Spec == Init /\ [][Next]_vars

TypeOK == /\ Len(ch) <= Cap
          /\ sent \in 0..N
          /\ Len(got) <= N

InOrder == got = [i \in 1..Len(got) |-> i]

=============================================================================
