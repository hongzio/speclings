----------------------------- MODULE 024_exists -----------------------------
EXTENDS Integers
\* tlings 024: Next 안의 \E
\*
\* Next 안의 \E 는 식을 TRUE 로 만드는 값마다 step 하나씩을 허용합니다.
\*
\*   \E n \in 1..3 : x' = x + n     모든 상태에서 가능한 step 세 개
\*
\* 유한 집합에 대한 \E 는 값마다 선언항이 하나씩 있는 \/ 와 같습니다.
\* "어떤 worker 가 step 을 밟는다" 를 이렇게 씁니다:
\* \E w \in Workers : Step(w).
\*
\* worker 세 명이 각자 일을 하나씩, 아무 순서로나 끝냅니다. 모두 끝내면
\* 다 같이 처음부터 다시 시작합니다. Next 를 쓰세요: 어떤 worker 가
\* 끝내거나, 모두 다시 시작한다.

Workers == {"w1", "w2", "w3"}

VARIABLE done    \* 일을 끝낸 worker 의 집합

Init == done = {}

Finish(w) == /\ w \notin done
             /\ done' = done \cup {w}

Restart == /\ done = Workers
           /\ done' = {}

Next == ???

=============================================================================
