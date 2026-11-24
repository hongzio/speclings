---------------------------- MODULE 006_bullets -----------------------------
EXTENDS Integers
\* tlings 006: /\ 와 \/ 목록
\*
\* 긴 식은 /\ 나 \/ 로 시작하는 목록으로 씁니다.
\*
\*   /\ A        A /\ B /\ C 라는 뜻
\*   /\ B
\*   /\ C
\*
\* 기호의 열(column)이 중요합니다. 괄호 역할을 하기 때문입니다. 목록은
\* 그 기호들보다 왼쪽에서 시작하는 줄, 또는 같은 열에서 다른 기호로
\* 시작하는 줄에서 끝납니다. 아래 둘은 들여쓰기만 다릅니다.
\*
\*   Nested == /\ FALSE          FALSE /\ (TRUE \/ TRUE)    = FALSE
\*             /\ \/ TRUE
\*                \/ TRUE
\*
\*   Flat   == /\ FALSE          (FALSE /\ TRUE) \/ TRUE    = TRUE
\*             /\ \/ TRUE
\*             \/ TRUE
\*
\* ASSUME P 는 ASSUME P = TRUE 와 같습니다.
\*
\* SmallOrEven(x) 는 "x 가 음수가 아니고, 작거나(10 미만) 짝수다" 라는
\* 뜻이어야 합니다. 들여쓰기만 고쳐서 ASSUME 이 모두 참이 되게 하세요.

SmallOrEven(x) == /\ x >= 0
                  /\ \/ x < 10
                  \/ x % 2 = 0

ASSUME SmallOrEven(3)
ASSUME SmallOrEven(12)
ASSUME ~SmallOrEven(-4)

=============================================================================
