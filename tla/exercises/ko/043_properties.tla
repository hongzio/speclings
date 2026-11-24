--------------------------- MODULE 043_properties ---------------------------
EXTENDS Integers
\* speclings tla 043: 속성
\*
\* 불변식은 한 번에 상태 하나에 대해 말합니다. 속성(property)은 behavior
\* 전체에 대해 말하므로, step 과 미래에 대해서도 말할 수 있습니다. 속성은
\* .cfg 에 적습니다.
\*
\*   PROPERTY NeverBackwards
\*
\* [] ("언제나") 만으로 되는 속성이 두 종류 있습니다.
\*
\*   []P         모든 상태에서 P 가 성립한다: 속성으로 쓴 불변식
\*   [][A]_v     모든 step 이 A 를 만족하거나 v 를 그대로 둔다
\*
\* 두 번째는 어떤 불변식도 못 하는 말, 즉 값이 한 상태에서 다음 상태로
\* 어떻게 바뀌는지를 말합니다. A 안에서 v 는 step 전의 값, v' 는 step
\* 뒤의 값입니다.
\*
\* 설정 서비스가 버전 1, 2, 3, ... 을 발행하고, 클라이언트는 버전이 절대
\* 뒤로 가지 않는다고 믿습니다. NeverBackwards, "모든 step 은 version 을
\* 그대로 두거나 키운다" 를 쓰고 .cfg 에 속성으로 추가하세요. 스펙에
\* Rollback action 이 있으므로 TLC 가 속성 위반을 찾아야 하고, 찾으면
\* speclings 가 통과시킵니다.

VARIABLE version

vars == <<version>>

Init == version = 0

Publish == /\ version < 3
           /\ version' = version + 1

Rollback == /\ version > 0
            /\ version' = version - 1

Next == Publish \/ Rollback

Spec == Init /\ [][Next]_vars

NeverBackwards == ???

=============================================================================
