---------------------------- MODULE 005_booleans ----------------------------
EXTENDS Integers
\* tlings 005: 불리언
\*
\* TLA+ 에는 TRUE 와 FALSE 두 값(둘을 모은 집합은 BOOLEAN)과 다음이 있습니다.
\*
\*   A /\ B     그리고               (Go: A && B)
\*   A \/ B     또는                 (Go: A || B)
\*   ~A         아님                 (Go: !A)
\*   a = b      같음                 (Go: a == b)
\*   a # b      다름, a /= b 로도 씀  (Go: a != b)
\*   A => B     함의: "A 이면 B"
\*   A <=> B    A 와 B 의 참거짓이 같음
\*
\* Go 에는 => 가 없지만, 스펙에서는 어디에나 나옵니다. "계좌가 닫혔으면
\* 잔고는 0 이다" 처럼요. A => B 는 A 가 TRUE 이고 B 가 FALSE 일 때만
\* FALSE 입니다. A 가 FALSE 이면 B 와 상관없이 TRUE 입니다.
\*
\* 괄호를 아끼지 마세요. 우선순위는 틀리기 쉽습니다.
\*
\* ??? 를 각각 TRUE 나 FALSE 로 바꾸세요.

ASSUME (TRUE /\ FALSE) = ???
ASSUME (TRUE \/ FALSE) = ???
ASSUME (~TRUE) = ???
ASSUME (1 # 2) = ???
ASSUME (FALSE => FALSE) = ???
ASSUME (TRUE => FALSE) = ???
ASSUME ((1 < 2) <=> (3 < 2)) = ???

=============================================================================
