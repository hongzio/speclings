-------------------------- MODULE 011_set_builders --------------------------
EXTENDS Integers
\* tlings 011: building sets
\*
\*   {x \in S : P}    filter: the elements x of S for which P holds
\*                    {x \in 1..6 : x % 2 = 0} = {2, 4, 6}
\*
\*   {e : x \in S}    map: the value of e for each x in S
\*                    {x * x : x \in 1..3} = {1, 4, 9}
\*
\* They look alike. Read what comes before the colon: "x \in S" means
\* filtering S; an expression means mapping.
\*
\* Write the definitions. Listing the elements will not work: each one is
\* checked on more than one input.

\* the elements of S that are multiples of 3
MultiplesOf3(S) == {x \in S : x % 3 = 0}

\* every element of S plus one
Inc(S) == {x + 1 : x \in S}

ASSUME MultiplesOf3(1..10) = {3, 6, 9}
ASSUME MultiplesOf3({4, 5}) = {}
ASSUME Inc({1, 5}) = {2, 6}
ASSUME Inc({}) = {}

=============================================================================
