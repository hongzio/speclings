----------------------------- MODULE 024_exists -----------------------------
EXTENDS Integers
\* speclings tla 024: \E in Next
\*
\* \E in Next allows one step for each value that makes it TRUE:
\*
\*   \E n \in 1..3 : x' = x + n     three possible steps from every state
\*
\* \E over a finite set is a \/ with one disjunct per value. It is how a
\* spec says "some worker takes a step": \E w \in Workers : Step(w).
\*
\* Three workers each finish a job, in any order. When all of them have
\* finished, they all start over. Write Next: some worker finishes, or
\* everyone restarts.

Workers == {"w1", "w2", "w3"}

VARIABLE done    \* the set of workers that have finished

Init == done = {}

Finish(w) == /\ w \notin done
             /\ done' = done \cup {w}

Restart == /\ done = Workers
           /\ done' = {}

Next == ???

=============================================================================
