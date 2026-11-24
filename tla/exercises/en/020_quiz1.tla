----------------------------- MODULE 020_quiz1 ------------------------------
EXTENDS Integers, FiniteSets
\* speclings tla 020: quiz
\*
\* Two goroutines each call Transfer(from, to, amt) once. To check every
\* way that can happen, a spec first needs the set of all possible calls.
\*
\* A request is a record with fields from and to (two different accounts)
\* and amt (an amount from 1 to MaxAmount).
\*
\*   Requests       the set of all requests
\*   Assignments    the set of all ways to give each worker one request
\*
\* Then work out how many of each there are, and let TLC check your math.

Accounts == {"alice", "bob", "carol"}
Workers == {"w1", "w2"}
MaxAmount == 2

Requests == ???

Assignments == ???

ASSUME [from |-> "alice", to |-> "bob", amt |-> 2] \in Requests
ASSUME [from |-> "alice", to |-> "alice", amt |-> 1] \notin Requests
ASSUME [from |-> "alice", to |-> "bob", amt |-> 0] \notin Requests
ASSUME [w \in Workers |-> [from |-> "bob", to |-> "carol", amt |-> 1]] \in Assignments
ASSUME Cardinality(Requests) = ???
ASSUME Cardinality(Assignments) = ???

=============================================================================
