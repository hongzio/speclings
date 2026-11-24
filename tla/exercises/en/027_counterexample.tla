------------------------- MODULE 027_counterexample -------------------------
EXTENDS Integers
\* tlings 027: reading a counterexample
\*
\* When an invariant fails, TLC prints the behavior that leads to the bad
\* state, one state per step:
\*
\*   State 1: <Initial predicate>
\*   /\ ew = "red"
\*   /\ ns = "green"
\*
\*   State 2: <NsTurn line ..., col ... of module 027_counterexample>
\*   ...
\*
\* Every state after the first is labeled with the action that produced
\* it. Reading the trace backwards from the bad state usually shows which
\* action took a step it should not have.
\*
\* Two traffic lights guard a crossing: north-south (ns) and east-west
\* (ew). Each goes green -> yellow -> red -> green. A light may turn green
\* only while the other one is red, so that at least one of them is always
\* red (Safe). TLC finds Safe violated. Read the trace, find the bug and
\* fix it.

VARIABLES ns, ew

Colors == {"green", "yellow", "red"}

After(c) == CASE c = "green"  -> "yellow"
              [] c = "yellow" -> "red"
              [] c = "red"    -> "green"

Init == ns = "green" /\ ew = "red"

NsTurn == /\ ns = "red" => ew = "red"
          /\ ns' = After(ns)
          /\ UNCHANGED ew

EwTurn == /\ ew = "red" => ns # "green"
          /\ ew' = After(ew)
          /\ UNCHANGED ns

Next == NsTurn \/ EwTurn

TypeOK == ns \in Colors /\ ew \in Colors

Safe == ns = "red" \/ ew = "red"

=============================================================================
