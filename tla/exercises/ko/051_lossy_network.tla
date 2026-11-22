------------------------- MODULE 051_lossy_network --------------------------
\* tlings 051: 메시지를 잃어버리는 네트워크
\*
\* 클라이언트가 요청을 보내고 응답을 기다립니다. 네트워크는 어떤 메시지든
\* 잃어버릴 수 있으므로, 클라이언트는 전송 중인 메시지가 없으면 요청을 다시
\* 보냅니다. msgs 는 전송 중인 메시지의 집합입니다.
\*
\*   Send     클라이언트가 "req" 를 보낸다
\*   Serve    서버가 응답한다: "req" 가 "resp" 가 된다
\*   Recv     클라이언트가 "resp" 를 받고 끝난다
\*   Retry    전송 중인 것이 없다: 클라이언트가 "req" 를 다시 보낸다
\*   Lose     네트워크가 메시지 하나를 버린다
\*
\* WF_vars(Next) 가 있어도 EventuallyDone 이 깨집니다. 반례의 고리에서는
\* 모든 요청이 서버에 닿기 전에 사라집니다. 실제 네트워크도 한동안은 그럴 수
\* 있지만 영원히는 아닙니다. 계속해서 다시 보낸 메시지는 결국 도착한다고
\* 가정합니다. 그것이 전달에 대한 강한 공정성(047)입니다. Serve 와 Recv 는
\* 계속해서 가능해지므로 결국 일어나야 합니다.
\*
\* Spec 에 SF_vars(Serve) 와 SF_vars(Recv) 를 추가하세요.
\*
\* 팁: 긴 반례는 alias 를 쓰면 읽기 쉽습니다. 각 상태에서 보고 싶은 것을
\* 레코드로 정의하고 (예: View == [client |-> client, inFlight |-> msgs]),
\* .cfg 에 ALIAS View 를 추가하세요. 그러면 TLC 는 변수 대신 View 를
\* 출력합니다.

VARIABLES client, msgs

vars == <<client, msgs>>

Init == /\ client = "send"
        /\ msgs = {}

Send == /\ client = "send"
        /\ msgs' = msgs \cup {"req"}
        /\ client' = "waiting"

Serve == /\ "req" \in msgs
         /\ msgs' = (msgs \ {"req"}) \cup {"resp"}
         /\ UNCHANGED client

Recv == /\ client = "waiting"
        /\ "resp" \in msgs
        /\ msgs' = msgs \ {"resp"}
        /\ client' = "done"

Retry == /\ client = "waiting"
         /\ msgs = {}
         /\ msgs' = {"req"}
         /\ UNCHANGED client

Lose == /\ \E m \in msgs : msgs' = msgs \ {m}
        /\ UNCHANGED client

Terminating == /\ client = "done"
               /\ UNCHANGED vars

Next == Send \/ Serve \/ Recv \/ Retry \/ Lose \/ Terminating

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

EventuallyDone == <>(client = "done")

=============================================================================
