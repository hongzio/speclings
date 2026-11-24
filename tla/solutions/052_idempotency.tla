-------------------------- MODULE 052_idempotency ---------------------------
EXTENDS Integers
\* tlings 052: idempotency
\*
\* Retries (051) have a price. When the response is lost, the client cannot
\* tell whether the server got the request, so it sends it again, and the
\* server may process the same request twice. Here the request is a
\* payment, and TLC finds ChargedOnce violated: the customer was charged
\* twice.
\*
\* The usual fix is an idempotency key: every request carries an ID, and
\* the server remembers which IDs it has already applied. A repeated
\* request gets its response again without being applied again.
\*
\* There is a single request here, so the server only has to remember
\* whether it has applied it: the variable applied. Change Serve so that it
\* charges only the first time, and records that it has.
\*
\*   go run ./tla/go/052_retry          payments charged twice
\*   go run ./tla/go/052_retry -fix     with an idempotency key

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
         /\ charged' = IF applied THEN charged ELSE charged + 1
         /\ applied' = TRUE
         /\ UNCHANGED client

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
