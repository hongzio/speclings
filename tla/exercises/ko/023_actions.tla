---------------------------- MODULE 023_actions -----------------------------
EXTENDS Integers
\* speclings tla 023: action 과 \/
\*
\* Next 는 보통 여러 종류의 step 을 허용합니다. 각 종류를 action 이라고
\* 부르고, Next 는 그것들의 선언(\/)입니다.
\*
\*   Next == Open \/ Close \/ Lock \/ Unlock
\*
\* TLC 는 모든 상태에서 모든 action 을 시도하므로 behavior 가 갈라집니다.
\* 스펙은 다음에 어떤 step 이 올지가 아니라, 어떤 step 이 가능한지만
\* 말합니다. "어떤 goroutine 이든 다음에 실행될 수 있다", "사용자는 어떤
\* 버튼이든 누를 수 있다" 를 이렇게 표현합니다.
\*
\* Open 의 door = "closed" 처럼 프라임이 없는 연언은 guard 입니다. 그것이
\* TRUE 인 상태에서만 그 action 이 일어날 수 있습니다.
\*
\* Lock 을 쓰세요: 잠기지 않은 닫힌 문은 잠글 수 있습니다. 그다음 Next 에
\* Lock 을 더하세요. guard 가 맞지 않으면 TLC 는 있을 수 없는 상태, 즉
\* 잠긴 열린 문에 도달하고 상태 수가 어긋납니다.

VARIABLES door, locked

Init == door = "closed" /\ locked = FALSE

Open   == /\ door = "closed"
          /\ ~locked
          /\ door' = "open"
          /\ UNCHANGED locked

Close  == /\ door = "open"
          /\ door' = "closed"
          /\ UNCHANGED locked

Lock   == ???

Unlock == /\ locked
          /\ locked' = FALSE
          /\ UNCHANGED door

Next == Open \/ Close \/ Unlock

=============================================================================
