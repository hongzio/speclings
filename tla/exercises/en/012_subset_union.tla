-------------------------- MODULE 012_subset_union --------------------------
EXTENDS Integers, FiniteSets
\* speclings tla 012: SUBSET, UNION and Cardinality
\*
\*   SUBSET S          the set of all subsets of S
\*                     SUBSET {1, 2} = {{}, {1}, {2}, {1, 2}}
\*   UNION S           S is a set of sets: merge them into one set
\*                     UNION {{1}, {2, 3}} = {1, 2, 3}
\*   Cardinality(S)    the number of elements of a finite set S
\*                     (from the FiniteSets module)
\*
\* A set of n elements has 2^n subsets. Keep that in mind: TLC has to
\* enumerate what you write, and SUBSET grows fast.
\*
\* Fill in the blanks.

ASSUME Cardinality({4, 5, 6}) = ???
ASSUME Cardinality(SUBSET {1, 2, 3}) = ???
ASSUME UNION {{1, 2}, {2, 3}, {}} = ???
ASSUME ({1} \in SUBSET {1, 2}) = ???
ASSUME SUBSET {} = ???

=============================================================================
