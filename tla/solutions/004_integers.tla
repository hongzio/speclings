---------------------------- MODULE 004_integers ----------------------------
EXTENDS Integers, TLC
\* tlings 004: integers
\*
\* From here on, ??? marks a blank for you to fill in. TLC cannot read ???,
\* so until you replace it you get a "Lexical error" that points at it.
\*
\* The Integers module gives you Int (all integers), negative numbers and:
\*
\*   + - *       as usual
\*   a \div b    integer division
\*   a % b       remainder (b must be positive)
\*   a..b        the set of integers from a to b: 1..3 = {1, 2, 3}
\*
\* Careful if you know Go: TLA+ integer division rounds down, toward minus
\* infinity, while Go rounds toward zero. (-7) \div 2 is -4 in TLA+ but
\* -7 / 2 is -3 in Go, and a TLA+ remainder is never negative.
\* Put negative numbers in parentheses: -7 \div 2 means -(7 \div 2).
\*
\* a..b is a set (sets come in 009). If a > b, it is the empty set {}.
\*
\* Tip: PrintT(e) prints the value of e and is always TRUE, so
\*   ASSUME PrintT((-7) % 2)
\* shows you a value while you experiment. PrintT is in the TLC module.

ASSUME 7 \div 2 = 3
ASSUME 7 % 2 = 1
ASSUME (-7) \div 2 = -4
ASSUME (-7) % 2 = 1
ASSUME 2..4 = {2, 3, 4}
ASSUME 5..4 = {}

=============================================================================
