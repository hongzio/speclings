----------------------------- MODULE 016_except -----------------------------
EXTENDS Integers
\* tlings 016: EXCEPT
\*
\* Values never change in TLA+. You do not modify a function; you write a
\* new one that is the same except at some keys:
\*
\*   [f EXCEPT ![k] = v]              f, with the value at k replaced by v
\*   [f EXCEPT ![k] = @ + 1]          @ is the old value f[k]
\*   [f EXCEPT ![a] = 1, ![b] = 2]    several keys at once
\*
\* In Go terms: g := clone(f); g[k] = v. f itself stays the same.
\*
\* Move(b, from, to, amt) is the balance function b after moving amt from
\* account "from" to account "to". Write it with one EXCEPT.

bal == [a \in {"alice", "bob"} |-> 10]

Move(b, from, to, amt) == [b EXCEPT ![from] = @ - amt, ![to] = @ + amt]

ASSUME Move(bal, "alice", "bob", 3)["alice"] = 7
ASSUME Move(bal, "alice", "bob", 3)["bob"] = 13
ASSUME DOMAIN Move(bal, "alice", "bob", 3) = {"alice", "bob"}
ASSUME bal["alice"] = 10
ASSUME [bal EXCEPT !["bob"] = @ * 2]["bob"] = 20

=============================================================================
