----------------------------- MODULE 042_quiz4 ------------------------------
EXTENDS Integers, Sequences
\* speclings tla 042: 퀴즈
\*
\* producer 들이 채널로 job 을 보내고, consumer 는 채널이 닫힐 때까지
\* range 로 받습니다. 누군가는 채널을 닫아야 하는데, 너무 일찍 닫는 것은
\* 흔한 버그입니다.
\*
\*   jobs := make(chan string, 1)
\*   for _, p := range producers {
\*       go func() { jobs <- p }()       // send
\*   }
\*   go func() { close(jobs) }()         // close: 너무 이르다
\*   for j := range jobs {               // recv, 닫히고 빌 때까지
\*       got = append(got, j)
\*   }
\*
\* 닫힌 채널에 보내면 "send on closed channel" 로 panic 이 납니다. 스펙은
\* 이것을 producer 의 pc 가 "panic" 이 되는 것으로 모델링합니다.
\*
\*   1. NoPanic, "어떤 producer 도 panic 하지 않는다" 를 쓰고 .cfg 에
\*      추가하세요.
\*   2. TLC 가 위반을 찾습니다. Go 코드가 하는 방식대로 WaitGroup 으로
\*      Close 를 고치세요: go func() { wg.Wait(); close(jobs) }(). 스펙에서는
\*      모든 producer 가 끝난 뒤에만 Close 가 가능하다는 뜻입니다.
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

\* 채널이 닫히고 비면 range 가 끝난다
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

\* consumer 가 끝나면 모든 job 을 받은 상태다
AllReceived == consumer = "done" => got = Producers

=============================================================================
