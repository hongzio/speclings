--------------------------- MODULE 043_properties ---------------------------
EXTENDS Integers
\* speclings tla 043: properties
\*
\* An invariant talks about one state at a time. A property talks about a
\* whole behavior, so it can also talk about steps and about the future.
\* You list properties in the .cfg:
\*
\*   PROPERTY NeverBackwards
\*
\* Two kinds of property need only [] ("always"):
\*
\*   []P         P holds in every state: an invariant, written as a property
\*   [][A]_v     every step either satisfies A or leaves v unchanged
\*
\* The second says what no invariant can: how values change from one state
\* to the next. Inside A, v is the value before the step and v' the value
\* after it.
\*
\* A config service publishes versions 1, 2, 3, ... and its clients rely
\* on the version never going backwards. Write NeverBackwards, "every step
\* leaves version the same or larger", and add it to the .cfg as a
\* property. The spec has a Rollback action, so TLC should find the
\* property violated, and speclings passes when it does.

VARIABLE version

vars == <<version>>

Init == version = 0

Publish == /\ version < 3
           /\ version' = version + 1

Rollback == /\ version > 0
            /\ version' = version - 1

Next == Publish \/ Rollback

Spec == Init /\ [][Next]_vars

NeverBackwards == [][version' >= version]_version

=============================================================================
