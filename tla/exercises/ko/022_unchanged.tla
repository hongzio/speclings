--------------------------- MODULE 022_unchanged ----------------------------
EXTENDS Integers
\* speclings tla 022: UNCHANGED
\*
\* step 은 모든 변수에 다음 상태의 값을 줘야 합니다. Next 가 어떤 변수에
\* 대해 아무 말도 하지 않으면 다음 값이 무엇이든 될 수 있으므로, TLC 는
\* "Successor state is not completely specified" 를 내고 멈춥니다.
\*
\* 변수가 값을 유지한다고 말하려면:
\*
\*   UNCHANGED alarm              alarm' = alarm 과 같음
\*   UNCHANGED <<hour, alarm>>    hour' = hour /\ alarm' = alarm 과 같음
\*
\* 이 Init 은 알람 시각마다 하나씩, 초기 상태를 두 개 허용합니다. Init 에서
\* \in 은 "이 중 아무거나" 라는 뜻입니다. TLC 는 둘 다에서 탐색합니다.
\*
\* 시계가 도는 동안 알람 시각은 바뀌지 않습니다. Next 를 고치세요.

VARIABLES hour, alarm

Init == /\ hour = 0
        /\ alarm \in {6, 7}

Next == hour' = (hour + 1) % 12

=============================================================================
