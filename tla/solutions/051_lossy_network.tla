------------------------- MODULE 051_lossy_network --------------------------
\* speclings tla 051: a lossy network
\*
\* A client sends a request and waits for the response. The network may
\* lose any message, so the client sends the request again whenever
\* nothing is in flight. msgs is the set of messages in flight.
\*
\*   Send     the client sends "req"
\*   Serve    the server answers: "req" becomes "resp"
\*   Recv     the client receives "resp" and is done
\*   Retry    nothing is in flight: the client sends "req" again
\*   Lose     the network drops a message
\*
\* EventuallyDone fails even with WF_vars(Next). In the loop of the
\* counterexample, every request is lost before the server sees it. A real
\* network can do that for a while, but not forever: we assume that a
\* message sent again and again eventually gets through. That is strong
\* fairness (047) on delivery: Serve and Recv are enabled again and again,
\* so they must eventually happen.
\*
\* Add SF_vars(Serve) and SF_vars(Recv) to Spec.
\*
\* Tip: long counterexamples are easier to read with an alias. Define a
\* record of what you want to see in each state, such as
\* View == [client |-> client, inFlight |-> msgs], and add ALIAS View to
\* the .cfg. TLC then prints View instead of the variables.

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

Spec == Init /\ [][Next]_vars /\ WF_vars(Next) /\ SF_vars(Serve) /\ SF_vars(Recv)

EventuallyDone == <>(client = "done")

=============================================================================
