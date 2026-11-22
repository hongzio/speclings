------------------------------ MODULE 031_spec ------------------------------
EXTENDS Integers
\* tlings 031: 식 하나로 된 스펙
\*
\* Init 과 Next 는 보통 식 하나로 합칩니다.
\*
\*   Spec == Init /\ [][Next]_vars
\*
\* [] 는 "언제나" 라는 뜻이고, [A]_v 는 A \/ UNCHANGED v 입니다. 그러니
\* Spec 은 이렇게 말합니다: 첫 상태는 Init 을 만족하고, 모든 step 은 Next
\* 를 만족하거나 모든 변수를 그대로 둔다.
\*
\* 아무것도 바꾸지 않는 step 을 stuttering step 이라고 하고, Spec 은 이를
\* 언제나 허용합니다. 이것은 Part 4 에서 중요해집니다. 영원히 stuttering
\* 할 수 있는 스펙은 무슨 일이든 결국 일어난다고 약속하지 않습니다.
\*
\* .cfg 에서는 SPECIFICATION Spec 이 INIT 과 NEXT 를 대신합니다. 이 .cfg
\* 는 이미 그것을 쓰고, 이후 문제들도 그렇습니다. vars 와 Spec 을 쓰세요.

VARIABLES hour, alarm

vars == ???

Init == /\ hour = 0
        /\ alarm \in {6, 7}

Next == /\ hour' = (hour + 1) % 12
        /\ UNCHANGED alarm

Spec == ???

=============================================================================
