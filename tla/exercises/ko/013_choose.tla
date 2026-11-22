----------------------------- MODULE 013_choose -----------------------------
EXTENDS Integers
\* tlings 013: CHOOSE
\*
\*   CHOOSE x \in S : P    S 의 원소 중 P 가 성립하는 어떤 x
\*
\* CHOOSE 는 무작위가 아닙니다. 같은 S 와 P 에 대해 항상 같은 원소를
\* 주므로, (CHOOSE x \in S : P) = (CHOOSE x \in S : P) 는 언제나 TRUE
\* 입니다. 어느 원소인지는 TLA+ 가 정하지 않으니 절대 기대지 마세요.
\* P 를 만족하는 원소가 없으면 TLC 가 에러를 보고합니다.
\*
\* CHOOSE 는 P 를 만족하는 원소가 정확히 하나일 때 가장 쓸모 있습니다.
\* "P 를 만족하는 그 x" 를 정의하는 방법입니다. 다음에 어느 goroutine 이
\* 실행될지 같은 임의의 선택은 CHOOSE 가 아니라 Part 2 의 \E 로 표현합니다.

\* S 의 가장 큰 원소
Max(S) == CHOOSE x \in S : ???

ASSUME Max({3, 9, 4}) = 9
ASSUME Max({-1}) = -1
\* TRUE 일까요, FALSE 일까요?
ASSUME ((CHOOSE x \in 1..10 : x > 3) = (CHOOSE x \in 1..10 : x > 3)) = ???

=============================================================================
