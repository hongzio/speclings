--------------------------- MODULE 029_constants ----------------------------
EXTENDS Integers, FiniteSets
\* tlings 029: CONSTANTS and model values
\*
\* Hard-coded sizes, like 3 cars, make a spec hard to reuse. Declare them
\* as constants instead, and give their values in the .cfg:
\*
\*   CONSTANTS Capacity, Cars           in the .tla
\*
\*   CONSTANTS                          in the .cfg
\*       Capacity = 2
\*       Cars = {c1, c2, c3}
\*
\* c1, c2 and c3 are model values: for each such name TLC makes up a value
\* that is equal only to itself. Use them for things that only need to be
\* told apart, like cars, accounts or goroutines.
\*
\* Fill in the .cfg so that TLC checks this spec with room for 2 cars and
\* the three cars c1, c2 and c3.

CONSTANTS Capacity, Cars

VARIABLE parked    \* the set of cars in the lot

Init == parked = {}

Enter(c) == /\ c \notin parked
            /\ Cardinality(parked) < Capacity
            /\ parked' = parked \cup {c}

Leave(c) == /\ c \in parked
            /\ parked' = parked \ {c}

Next == \E c \in Cars : Enter(c) \/ Leave(c)

TypeOK == parked \subseteq Cars /\ Cardinality(parked) <= Capacity

=============================================================================
