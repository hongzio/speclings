-------------------------- MODULE 008_conditionals --------------------------
EXTENDS Integers
\* tlings 008: IF, CASE, LET
\*
\*   IF c THEN a ELSE b    문장이 아니라 식입니다. 값이 있어야 하므로 ELSE 가
\*                         반드시 필요합니다
\*
\*   CASE c1 -> a          참인 조건의 값입니다. 여럿이 참이면 어느 것을
\*     [] c2 -> b          쓸지 TLA+ 는 정하지 않으니, 서로 겹치지 않게
\*     [] OTHER -> d       쓰세요. OTHER 는 모두 거짓일 때 쓰이고, 없으면
\*                         그 경우 에러입니다.
\*
\*   LET x == e IN body    body 안에서만 있는 정의
\*
\* 아래에 버그가 세 개 있고, TLC 는 하나씩 보고합니다.

Abs(x) == IF x < 0 THEN -x

Sign(x) == CASE x > 0 -> 1
             [] x < 0 -> -1

\* a 와 b 사이의 거리
Dist(a, b) == LET d == ??? IN Abs(d)

ASSUME Abs(-3) = 3
ASSUME Abs(2) = 2
ASSUME Sign(-5) = -1
ASSUME Sign(0) = 0
ASSUME Dist(2, 7) = 5
ASSUME Dist(7, 2) = 5

=============================================================================
