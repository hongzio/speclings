------------------------------ MODULE 031_spec ------------------------------
EXTENDS Integers
\* speclings tla 031: the spec as one formula
\*
\* Init and Next are normally combined into a single formula:
\*
\*   Spec == Init /\ [][Next]_vars
\*
\* [] means "always", and [A]_v means A \/ UNCHANGED v. So Spec says: the
\* first state satisfies Init, and every step either satisfies Next or
\* leaves all the variables unchanged.
\*
\* A step that changes nothing is a stuttering step, and Spec always allows
\* it. That matters in Part 4: a spec that may stutter forever does not
\* promise that anything ever happens.
\*
\* In the .cfg, SPECIFICATION Spec replaces INIT and NEXT. This .cfg
\* already uses it, and so do the exercises from Part 3 on. Write vars and
\* Spec.

VARIABLES hour, alarm

vars == <<hour, alarm>>

Init == /\ hour = 0
        /\ alarm \in {6, 7}

Next == /\ hour' = (hour + 1) % 12
        /\ UNCHANGED alarm

Spec == Init /\ [][Next]_vars

=============================================================================
