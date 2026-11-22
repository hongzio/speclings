----------------------------- MODULE 003_assume -----------------------------
EXTENDS Naturals
\* tlings 003: ASSUME
\*
\* ASSUME P 는 "P 가 참이라고 가정한다" 는 선언입니다. TLC 는 상태를
\* 탐색하기 전에 모든 ASSUME 을 계산하고, 거짓인 것이 있으면 위치를
\* 알려주고 멈춥니다.
\*
\*   Error: Assumption line N, col M to ... of module 003_assume is false.
\*
\* tlings 는 ASSUME 을 단위 테스트의 assert 처럼 씁니다. 004 부터의
\* Part 1 문제는 대부분 "모든 ASSUME 이 참이 되게 하라" 입니다.
\*
\* 여기서 = 는 대입이 아니라 "같은가?" 를 묻는 비교입니다. Go 의 == 와
\* 같습니다. 그래서 Two = 2 는 TRUE 나 FALSE 하나로 계산됩니다.
\* TLA+ 에는 대입이 없습니다. 이 사실은 Part 2 에서 다시 중요해집니다.
\*
\* 아래 ASSUME 중 하나가 거짓입니다. TLC 에러 메시지의 line 번호로
\* 찾아서 고치세요. 왼쪽 식은 그대로 두고 오른쪽 값을 고치면 됩니다.

Two == 1 + 1

ASSUME Two = 2
ASSUME Two + Two = 4
ASSUME Two * Two = 4
ASSUME Two * Two * Two = 6
ASSUME Two < 3

=============================================================================
