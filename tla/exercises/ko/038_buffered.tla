---------------------------- MODULE 038_buffered ----------------------------
EXTENDS Integers, Sequences
\* tlings 038: 버퍼가 있는 채널
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
\* 버퍼가 있는 채널은 용량이 있는 FIFO 큐, 즉 시퀀스(018)입니다. 막히는
\* 규칙은 guard 가 됩니다.
\*
\*   ch <- v    Len(ch) < Cap 일 때만: 가득 찬 채널에 보내면 막힌다
\*   <-ch       ch # <<>> 일 때만: 빈 채널에서 받으면 막힌다
\*
\* 막힌 goroutine 이란 단지 다음 action 이 가능하지 않은 goroutine 입니다.
\* 여기서는 producer 의 반복 카운터 sent 가 pc 를 대신하고, consumer 는
\* Len(got) 가 대신합니다.
\*
\* Send 와 Recv 를 쓰세요. TypeOK 는 용량을, InOrder 는 값이 보낸 순서대로
\* 도착하는지를 검사합니다.

N == 3
Cap == 2

VARIABLES ch, sent, got

vars == <<ch, sent, got>>

Init == /\ ch = <<>>
        /\ sent = 0
        /\ got = <<>>

\* producer 가 sent + 1 을 보낸다
Send == ???

\* consumer 가 가장 오래된 값을 받는다
Recv == ???

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
