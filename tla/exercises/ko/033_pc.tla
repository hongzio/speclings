------------------------------- MODULE 033_pc -------------------------------
EXTENDS Integers
\* tlings 033: 프로그램 카운터
\*
\* 이제부터 스펙은 Go 코드를 모델링합니다. goroutine 하나로 시작합니다.
\*
\*   func incr() {
\*       tmp := counter       // read
\*       counter = tmp + 1    // write
\*   }                        // done
\*
\* TLA+ 에는 문장도 "다음 줄" 도 없습니다. 그래서 스펙은 코드의 현재 위치를
\* 별도의 변수에 담고, 관례상 pc (program counter) 라고 부릅니다. 각 줄은
\* pc 가 그 줄을 가리킬 때만 가능하고, 그 줄이 하는 일을 하고, pc 를 다음
\* 줄로 옮기는 action 이 됩니다.
\*
\*   Read == /\ pc = "read"        다음 줄이 "read" 일 때만
\*           /\ tmp' = counter     그 줄이 하는 일
\*           /\ pc' = "write"      다음 줄로 이동
\*           /\ UNCHANGED counter
\*
\* tmp 같은 지역 변수도 스펙의 변수가 됩니다.
\*
\* 두 번째 줄의 action 을 쓰세요. .cfg 에 있는 Correct 는 incr 가 정말로
\* 1 을 더하는지 검사합니다.

VARIABLES counter, tmp, pc

vars == <<counter, tmp, pc>>

Init == /\ counter = 0
        /\ tmp = 0
        /\ pc = "read"

Read == /\ pc = "read"
        /\ tmp' = counter
        /\ pc' = "write"
        /\ UNCHANGED counter

Write == ???

Terminating == /\ pc = "done"
               /\ UNCHANGED vars

Next == Read \/ Write \/ Terminating

Spec == Init /\ [][Next]_vars

\* incr 가 return 한 뒤에는 counter 가 1 이다
Correct == pc = "done" => counter = 1

=============================================================================
