-------------------------- MODULE 052_idempotency ---------------------------
EXTENDS Integers
\* tlings 052: 멱등성
\*
\* 재시도(051)에는 대가가 있습니다. 응답을 잃어버리면 클라이언트는 서버가
\* 요청을 받았는지 알 수 없으니 다시 보내고, 서버는 같은 요청을 두 번 처리할
\* 수 있습니다. 여기서 요청은 결제이고, TLC 는 ChargedOnce 위반, 즉 고객이 두
\* 번 청구된 것을 찾습니다.
\*
\* 흔한 해결책은 멱등성 키(idempotency key)입니다. 모든 요청이 ID 를 갖고,
\* 서버는 이미 적용한 ID 를 기억합니다. 반복된 요청에는 다시 적용하지 않고
\* 응답만 다시 줍니다.
\*
\* 여기에는 요청이 하나뿐이므로 서버는 그것을 적용했는지만 기억하면 됩니다:
\* 변수 applied. Serve 가 처음에만 청구하고, 청구했다는 것을 기록하도록
\* 고치세요.
\*
\*   go run ./go/052_retry          두 번 청구된 결제
\*   go run ./go/052_retry -fix     멱등성 키를 쓴 경우

VARIABLES client, msgs, charged, applied

vars == <<client, msgs, charged, applied>>

Init == /\ client = "send"
        /\ msgs = {}
        /\ charged = 0
        /\ applied = FALSE

Send == /\ client = "send"
        /\ msgs' = msgs \cup {"req"}
        /\ client' = "waiting"
        /\ UNCHANGED <<charged, applied>>

Serve == /\ "req" \in msgs
         /\ msgs' = (msgs \ {"req"}) \cup {"resp"}
         /\ charged' = charged + 1
         /\ UNCHANGED <<client, applied>>

Recv == /\ client = "waiting"
        /\ "resp" \in msgs
        /\ msgs' = msgs \ {"resp"}
        /\ client' = "done"
        /\ UNCHANGED <<charged, applied>>

Retry == /\ client = "waiting"
         /\ msgs = {}
         /\ msgs' = {"req"}
         /\ UNCHANGED <<client, charged, applied>>

Lose == /\ \E m \in msgs : msgs' = msgs \ {m}
        /\ UNCHANGED <<client, charged, applied>>

Terminating == /\ client = "done"
               /\ UNCHANGED vars

Next == Send \/ Serve \/ Recv \/ Retry \/ Lose \/ Terminating

Spec == Init /\ [][Next]_vars

ChargedOnce == charged <= 1

=============================================================================
