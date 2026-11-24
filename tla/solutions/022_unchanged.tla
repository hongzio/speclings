--------------------------- MODULE 022_unchanged ----------------------------
EXTENDS Integers
\* tlings 022: UNCHANGED
\*
\* A step must give every variable a value in the next state. If Next says
\* nothing about a variable, its next value could be anything, and TLC
\* stops with "Successor state is not completely specified".
\*
\* To say that a variable keeps its value:
\*
\*   UNCHANGED alarm              means  alarm' = alarm
\*   UNCHANGED <<hour, alarm>>    means  hour' = hour /\ alarm' = alarm
\*
\* This Init allows two initial states, one for each alarm time: in Init,
\* \in means "any of these". TLC explores from both.
\*
\* The alarm time never changes while the clock runs. Fix Next.

VARIABLES hour, alarm

Init == /\ hour = 0
        /\ alarm \in {6, 7}

Next == /\ hour' = (hour + 1) % 12
        /\ UNCHANGED alarm

=============================================================================
