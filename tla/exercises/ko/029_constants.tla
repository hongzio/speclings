--------------------------- MODULE 029_constants ----------------------------
EXTENDS Integers, FiniteSets
\* tlings 029: CONSTANTS 와 model value
\*
\* 차 3 대 같은 크기를 스펙에 박아 넣으면 다시 쓰기 어렵습니다. 대신
\* 상수로 선언하고, 값은 .cfg 에서 줍니다.
\*
\*   CONSTANTS Capacity, Cars           .tla 에서
\*
\*   CONSTANTS                          .cfg 에서
\*       Capacity = 2
\*       Cars = {c1, c2, c3}
\*
\* c1, c2, c3 는 model value 입니다. TLC 는 이런 이름마다 자기 자신과만
\* 같은 값을 하나씩 만듭니다. 차, 계좌, goroutine 처럼 서로 구별만 되면
\* 되는 것에 쓰세요.
\*
\* .cfg 를 채워서, TLC 가 차 2 대가 들어가는 주차장과 차 c1, c2, c3 세
\* 대로 이 스펙을 검사하게 하세요.

CONSTANTS Capacity, Cars

VARIABLE parked    \* 주차장에 있는 차의 집합

Init == parked = {}

Enter(c) == /\ c \notin parked
            /\ Cardinality(parked) < Capacity
            /\ parked' = parked \cup {c}

Leave(c) == /\ c \in parked
            /\ parked' = parked \ {c}

Next == \E c \in Cars : Enter(c) \/ Leave(c)

TypeOK == parked \subseteq Cars /\ Cardinality(parked) <= Capacity

=============================================================================
