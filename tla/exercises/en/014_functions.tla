--------------------------- MODULE 014_functions ----------------------------
EXTENDS Integers
\* tlings 014: functions
\*
\* A TLA+ function is like a Go map whose keys are exactly its domain:
\*
\*   [x \in S |-> e]    the function that maps each x in S to e
\*   f[x]               the value of f at x
\*   DOMAIN f           the set of keys
\*
\*   sq == [x \in 1..3 |-> x * x]      sq[2] = 4, DOMAIN sq = 1..3
\*
\* Applying f outside its domain is an error, not a zero value as in Go.
\* Functions are values: two functions are equal when they have the same
\* domain and the same value at every key.
\*
\* Functions are not operators (007). An operator is an abbreviation used
\* as Op(x). A function is a value used as f[x]: you can store it in a
\* variable, compare it with = and take its DOMAIN.
\*
\* "alice" is a string. Strings are values, like numbers.

sq == [x \in 1..3 |-> x * x]

\* every account starts with a balance of 10
balance == ???

ASSUME sq[3] = ???
ASSUME DOMAIN sq = ???
ASSUME DOMAIN balance = {"alice", "bob"}
ASSUME balance["alice"] = 10 /\ balance["bob"] = 10

=============================================================================
