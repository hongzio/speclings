---------------------------- MODULE 006_bullets -----------------------------
EXTENDS Integers
\* speclings tla 006: /\ and \/ lists
\*
\* Long formulas are written as lists of /\ or \/ bullets:
\*
\*   /\ A        means A /\ B /\ C
\*   /\ B
\*   /\ C
\*
\* The column of the bullets matters, because it replaces parentheses.
\* A list ends at the first line that starts to the left of its bullets,
\* or at the same column with a different bullet. These two differ only
\* in indentation:
\*
\*   Nested == /\ FALSE          FALSE /\ (TRUE \/ TRUE)    = FALSE
\*             /\ \/ TRUE
\*                \/ TRUE
\*
\*   Flat   == /\ FALSE          (FALSE /\ TRUE) \/ TRUE    = TRUE
\*             /\ \/ TRUE
\*             \/ TRUE
\*
\* ASSUME P is the same as ASSUME P = TRUE.
\*
\* SmallOrEven(x) should mean: x is not negative, and x is small (less
\* than 10) or even. Fix only its indentation so that the ASSUMEs hold.

SmallOrEven(x) == /\ x >= 0
                  /\ \/ x < 10
                     \/ x % 2 = 0

ASSUME SmallOrEven(3)
ASSUME SmallOrEven(12)
ASSUME ~SmallOrEven(-4)

=============================================================================
