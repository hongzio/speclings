----------------------------- MODULE 032_quiz2 ------------------------------
EXTENDS Integers
\* tlings 032: quiz
\*
\* The classic water jug puzzle: you have a 3-gallon jug, a 5-gallon jug
\* and a tap. You may fill a jug, empty it, or pour one jug into the other
\* until the first is empty or the second is full. Can you measure exactly
\* 4 gallons?
\*
\* Let TLC solve it. Write an invariant that says "the big jug never holds
\* 4 gallons" and check it. If the puzzle can be solved, TLC reports the
\* invariant violated, and its counterexample is the shortest solution.
\* tlings passes when that happens.
\*
\* First finish the two pouring actions. Min(a, b) is the smaller of a and b.

Min(a, b) == IF a < b THEN a ELSE b

VARIABLES small, big

Init == small = 0 /\ big = 0

FillSmall  == small' = 3 /\ UNCHANGED big
FillBig    == big' = 5 /\ UNCHANGED small
EmptySmall == small' = 0 /\ UNCHANGED big
EmptyBig   == big' = 0 /\ UNCHANGED small

\* pour the small jug into the big one
SmallToBig == ???

\* pour the big jug into the small one
BigToSmall == ???

Next == \/ FillSmall
        \/ FillBig
        \/ EmptySmall
        \/ EmptyBig
        \/ SmallToBig
        \/ BigToSmall

TypeOK == small \in 0..3 /\ big \in 0..5

NotFour == ???

=============================================================================
