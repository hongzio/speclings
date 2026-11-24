------------------------ MODULE 046_fair_goroutines -------------------------
EXTENDS Integers
\* tlings 046: fairness for each goroutine
\*
\* Two goroutines loop forever, each counting 0, 1, 2, 0, 1, 2, ...
\* Progress says that both keep going: for every worker, count is 2 again
\* and again ([]<> means "infinitely often").
\*
\* Spec has WF_vars(Next), yet TLC finds Progress violated. Read the
\* counterexample. It ends with "Back to state", which marks a loop that
\* repeats forever, and in that loop only one goroutine runs. That is fair
\* to Next, which takes a step all the time, but not to the other
\* goroutine.
\*
\* To say that the scheduler eventually runs every goroutine that can run,
\* give each goroutine's own action fairness:
\*
\*   \A w \in Workers : WF_vars(Tick(w))
\*
\* Replace WF_vars(Next) in Spec with that.

CONSTANT Workers

VARIABLE count

vars == <<count>>

Init == count = [w \in Workers |-> 0]

Tick(w) == count' = [count EXCEPT ![w] = (@ + 1) % 3]

Next == \E w \in Workers : Tick(w)

Spec == Init /\ [][Next]_vars /\ \A w \in Workers : WF_vars(Tick(w))

Progress == \A w \in Workers : []<>(count[w] = 2)

=============================================================================
