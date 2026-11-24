-------------------------- MODULE 007_definitions ---------------------------
EXTENDS Integers
\* speclings tla 007: definitions
\*
\* Name == e defines Name to mean the expression e. Definitions can take
\* parameters:
\*
\*   Double(n) == n + n
\*
\* A definition is an abbreviation: Double(3) means exactly 3 + 3. There
\* is no function call and nothing runs in any order.
\*
\* One rule surprises Go programmers: a name can only be used below its
\* definition. There are no forward references.
\*
\* Define Sq(n), the square of n. Then make TLC accept SumOfSquares.

SumOfSquares(a, b) == Sq(a) + Sq(b)

Double(n) == n + n

Sq(n) == ???

ASSUME Double(4) = 8
ASSUME Sq(5) = 25
ASSUME SumOfSquares(3, 4) = 25

=============================================================================
