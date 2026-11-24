---------------------------- MODULE 045_leads_to ----------------------------
\* speclings tla 045: leads to
\*
\*   P ~> Q     whenever P holds, Q holds then or later: "P leads to Q"
\*
\* ~> is the usual shape of a liveness requirement: every request is
\* eventually answered, every message eventually delivered, every lock
\* request eventually granted. It is short for [](P => <>Q).
\*
\* For a property about every client, put a \A around the ~>:
\*
\*   \A c \in Clients : P(c) ~> Q(c)
\*
\* Clients send requests to a server. Write Answered, "every waiting client
\* is eventually answered", and add it to the .cfg as a property. Spec
\* already has fairness, but requests can get dropped, so TLC should find
\* Answered violated, and speclings passes when it does. Then read
\* the counterexample: what happened to the request?

CONSTANT Clients

VARIABLE state    \* for each client: "idle", "waiting", "answered" or "dropped"

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
