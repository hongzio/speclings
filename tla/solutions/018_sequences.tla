--------------------------- MODULE 018_sequences ----------------------------
EXTENDS Integers, Sequences
\* tlings 018: tuples and sequences
\*
\*   <<1, 2, 3>>        a tuple, also called a sequence; indexes start at 1
\*   s[i]               the i-th element
\*   Len(s)             the length
\*   Append(s, e)       s with e added at the end
\*   Head(s)            the first element
\*   Tail(s)            everything after the first element
\*   s \o t             s followed by t
\*   SubSeq(s, m, n)    elements m through n
\*   Seq(S)             the set of all sequences of elements of S (infinite)
\*
\* All except <<...>> and s[i] come from the Sequences module.
\*
\* A tuple is a function whose domain is 1..n, so DOMAIN <<"a", "b">> = 1..2.
\* TLC prints every function with domain 1..n as a tuple.
\*
\* A FIFO queue, like a buffered Go channel, is a sequence: send with
\* Append, receive with Head and Tail. Write Send and Receive.

\* queue after sending m
Send(queue, m) == Append(queue, m)

\* queue after receiving one message
Receive(queue) == Tail(queue)

ASSUME Send(<<>>, "a") = <<"a">>
ASSUME Send(<<"a">>, "b") = <<"a", "b">>
ASSUME Receive(<<"a", "b">>) = <<"b">>
ASSUME Receive(Send(<<"a">>, "b")) = <<"b">>
ASSUME Len(<<>>) = 0
ASSUME DOMAIN <<"x", "y", "z">> = 1..3

=============================================================================
