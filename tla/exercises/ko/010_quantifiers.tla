-------------------------- MODULE 010_quantifiers ---------------------------
EXTENDS Integers
\* speclings tla 010: \A 와 \E
\*
\*   \A x \in S : P     S 의 모든 x 에 대해 P 가 성립한다    ("모든")
\*   \E x \in S : P     P 가 성립하는 x 가 하나 이상 있다    ("존재")
\*
\* 불리언을 돌려주는 반복문으로 생각하면 됩니다.
\*
\*   \A:  for x in S { if !P { return false } }; return true
\*   \E:  for x in S { if P { return true } }; return false
\*
\* 그래서 공집합에 대해 \A 는 TRUE, \E 는 FALSE 입니다.
\*
\* 불변식은 대부분 \A 식입니다: "모든 계좌의 잔고는 0 이상이다".
\* 변수 여러 개를 한 번에: \A x, y \in S : P.
\*
\* ASSUME 이 모두 참이 되도록 두 정의를 쓰세요.

\* S 의 모든 원소가 양수다
AllPositive(S) == ???

\* S 에 n 보다 큰 원소가 있다
SomeAbove(S, n) == ???

ASSUME AllPositive({1, 2, 3})
ASSUME ~AllPositive({1, -2, 3})
ASSUME AllPositive({})
ASSUME SomeAbove({1, 5, 3}, 4)
ASSUME ~SomeAbove({1, 2}, 4)
ASSUME ~SomeAbove({}, 0)

=============================================================================
