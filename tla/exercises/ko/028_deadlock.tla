---------------------------- MODULE 028_deadlock ----------------------------
EXTENDS Integers
\* speclings tla 028: deadlock
\*
\* deadlock 은 어떤 step 도 가능하지 않은, 도달 가능한 상태입니다. TLC 는
\* 기본으로 deadlock 을 찾습니다. 대개 버그이기 때문입니다. Go 의 "fatal
\* error: all goroutines are asleep - deadlock!" 이 그런 예입니다.
\*
\* 하지만 return 하는 함수처럼 끝나도록 만든 시스템도 더 이상 step 이 없는
\* 상태로 끝납니다. 그게 의도라는 것을 TLC 에 알리려면, 일이 끝난 뒤에는
\* 아무것도 바꾸지 않는 step 을 허용합니다.
\*
\*   Terminating == /\ <일이 끝났다>
\*                  /\ UNCHANGED vars
\*
\* vars 는 모든 변수의 튜플에 관례적으로 붙이는 이름입니다.
\* (tlc 를 -deadlock 으로 실행하면 검사가 꺼지지만, 그러면 진짜 deadlock
\* 도 못 보고 지나칩니다.)
\*
\* speclings tla 를 실행해 TLC 가 보고하는 deadlock 을 읽어 보세요. 그다음
\* Terminating 을 쓰고 Next 에 더하세요.

VARIABLES received, status

vars == <<received, status>>

Init == received = 0 /\ status = "downloading"

Get == /\ status = "downloading"
       /\ received < 3
       /\ received' = received + 1
       /\ UNCHANGED status

Finish == /\ status = "downloading"
          /\ received = 3
          /\ status' = "done"
          /\ UNCHANGED received

Next == Get \/ Finish

=============================================================================
