---------------------------- MODULE 017_records -----------------------------
EXTENDS Integers, FiniteSets
\* tlings 017: records
\*
\*   [from |-> "alice", amt |-> 3]    a record, like a Go struct value
\*   r.amt                            a field
\*   [r EXCEPT !.amt = 5]             r with one field replaced
\*   [from : S, amt : T]              the set of ALL records whose from
\*                                    is in S and whose amt is in T
\*
\* A record is a function whose domain is a set of strings: r.amt is
\* r["amt"], and DOMAIN r is the set of field names. That is why EXCEPT
\* and DOMAIN work on records too.
\*
\* Fill in the blanks.

r == [from |-> "alice", to |-> "bob", amt |-> 3]

ASSUME r.to = "bob"
ASSUME r["amt"] = 3
ASSUME DOMAIN r = {"from", "to", "amt"}
ASSUME [r EXCEPT !.amt = @ + 1].amt = 4
ASSUME Cardinality([kind : {"deposit", "withdraw"}, amt : 1..3]) = 6

=============================================================================
