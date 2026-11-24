-------------------------- MODULE 007_definitions ---------------------------
EXTENDS Integers
\* speclings tla 007: 정의
\*
\* Name == e 는 Name 이 식 e 를 뜻한다고 정의합니다. 매개변수를 받을 수도
\* 있습니다.
\*
\*   Double(n) == n + n
\*
\* 정의는 줄임말입니다. Double(3) 은 정확히 3 + 3 을 뜻합니다. 함수 호출이
\* 아니고, 무엇도 순서대로 실행되지 않습니다.
\*
\* Go 프로그래머가 놀라는 규칙이 하나 있습니다. 이름은 그 정의보다 아래에서만
\* 쓸 수 있습니다. 앞쪽 참조(forward reference)가 없습니다.
\*
\* n 의 제곱인 Sq(n) 을 정의하세요. 그다음 TLC 가 SumOfSquares 를
\* 받아들이게 하세요.

SumOfSquares(a, b) == Sq(a) + Sq(b)

Double(n) == n + n

Sq(n) == ???

ASSUME Double(4) = 8
ASSUME Sq(5) = 25
ASSUME SumOfSquares(3, 4) = 25

=============================================================================
