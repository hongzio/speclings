--------------------------- MODULE 044_eventually ---------------------------
EXTENDS Integers
\* speclings tla 044: 결국, 그리고 공정성
\*
\*   <>P     어느 시점에는 P 가 성립한다: "결국 P"
\*
\* <> 는 liveness 속성을 만듭니다. 나쁜 일이 결코 일어나지 않는다는 것뿐
\* 아니라, 좋은 일이 결국 일어난다고 말합니다. .cfg 는 이 다운로드(028)가
\* 결국 끝나는지 검사하는데, TLC 는 "Stuttering" 으로 끝나는 반례와 함께
\* 속성 위반을 보고합니다.
\*
\* Spec 은 stuttering step 을 허용하고(031), 스펙 어디에도 behavior 가
\* 영원히 stuttering 하는 것을 막는 것이 없습니다. 다운로드가 그냥 멈춰도
\* Spec 은 여전히 성립합니다. 실제 프로세스는 계속 돌고, 스펙에서는 그것을
\* 공정성(fairness)으로 말합니다.
\*
\*   WF_vars(A)    약한 공정성: A 가 영원히 가능한 상태로 남아 있으면, A 는
\*                 결국 (vars 를 바꾸는 step 으로) 일어난다
\*
\* 프로세스가 하나라면 WF_vars(Next) 는 "진행할 수 있는 동안에는 멈추지
\* 않는다" 는 뜻입니다. Spec 에 세 번째 연언으로 추가하세요.

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

Terminating == /\ status = "done"
               /\ UNCHANGED vars

Next == Get \/ Finish \/ Terminating

Spec == Init /\ [][Next]_vars

EventuallyDone == <>(status = "done")

=============================================================================
