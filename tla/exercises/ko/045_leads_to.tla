---------------------------- MODULE 045_leads_to ----------------------------
\* speclings tla 045: leads to
\*
\*   P ~> Q     P 가 성립하면 그때나 그 뒤에 Q 가 성립한다: "P 는 Q 로 이어진다"
\*
\* ~> 는 liveness 요구사항의 흔한 모양입니다. 모든 요청은 결국 응답을 받고,
\* 모든 메시지는 결국 전달되고, 모든 lock 요청은 결국 허락된다. [](P => <>Q)
\* 의 줄임입니다.
\*
\* 모든 클라이언트에 대한 속성은 ~> 바깥에 \A 를 씌웁니다.
\*
\*   \A c \in Clients : P(c) ~> Q(c)
\*
\* 클라이언트가 서버에 요청을 보냅니다. Answered, "기다리는 클라이언트는
\* 결국 응답을 받는다" 를 쓰고 .cfg 에 속성으로 추가하세요. Spec 에는 이미
\* 공정성이 있지만 요청이 버려질 수 있으므로, TLC 가 Answered 위반을 찾아야
\* 하고, 찾으면 speclings 가 통과시킵니다. 그다음 반례를 읽어 보세요. 요청은
\* 어떻게 됐나요?

CONSTANT Clients

VARIABLE state    \* 클라이언트마다 "idle", "waiting", "answered", "dropped" 중 하나

vars == <<state>>

Init == state = [c \in Clients |-> "idle"]

Request(c) == /\ state[c] = "idle"
              /\ state' = [state EXCEPT ![c] = "waiting"]

Answer(c) == /\ state[c] = "waiting"
             /\ state' = [state EXCEPT ![c] = "answered"]

Drop(c) == /\ state[c] = "waiting"
           /\ state' = [state EXCEPT ![c] = "dropped"]

Terminating == /\ \A c \in Clients : state[c] \in {"answered", "dropped"}
               /\ UNCHANGED vars

Next == \/ \E c \in Clients : Request(c) \/ Answer(c) \/ Drop(c)
        \/ Terminating

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

Answered == ???

=============================================================================
