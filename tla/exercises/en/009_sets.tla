------------------------------ MODULE 009_sets ------------------------------
EXTENDS Integers
\* speclings tla 009: sets
\*
\*   {1, 2, 3}        a set. Order and repetition do not matter:
\*                    {1, 2} = {2, 1, 1}
\*   {}               the empty set
\*   x \in S          x is an element of S (x \notin S: it is not)
\*   S \cup T         union         {1, 2} \cup {2, 3} = {1, 2, 3}
\*   S \cap T         intersection  {1, 2} \cap {2, 3} = {2}
\*   S \ T            difference    {1, 2} \ {2, 3}    = {1}
\*   S \subseteq T    every element of S is in T
\*
\* Sets are the most used data structure in TLA+: the set of accounts, of
\* messages in flight, of possible requests...
\*
\* Fill in the blanks.

ASSUME {3, 1, 2} = {1, 2, ???}
ASSUME ({1, 2} \cup {2, 3}) = ???
ASSUME ({1, 2} \cap {2, 3}) = ???
ASSUME ({1, 2, 3} \ {2}) = ???
ASSUME (2 \in {1, 2, 3}) = ???
ASSUME ({1, 4} \subseteq 1..3) = ???
ASSUME ({} \subseteq {1}) = ???

=============================================================================
