--------------------------- MODULE 026_invariants ---------------------------
EXTENDS Integers
\* speclings tla 026: 불변식
\*
\* 불변식은 도달 가능한 모든 상태에서 TRUE 여야 하는, 상태 하나에 대한
\* 식입니다. 불변식은 .cfg 에 적습니다.
\*
\*   INVARIANT TypeOK
\*
\* TLC 는 찾는 상태마다 불변식을 검사합니다. 하나라도 FALSE 인 첫 상태에서
\* 멈추고, 그 상태에 이르는 behavior 를 출력합니다. 이것이 반례
\* (counterexample) 입니다.
\*
\* TypeOK 는 관례상 첫 번째 불변식입니다. 각 변수가 의도한 종류의 값을
\* 갖는다는 뜻입니다. TLA+ 에는 타입이 없으므로, 0..3 에 머물러야 할
\* 카운터가 4 가 된 것을 이렇게 알아챕니다.
\*
\* 이 주차장에는 Capacity 대가 들어갈 수 있습니다. TypeOK, "cars 는 0 부터
\* Capacity 사이의 수다" 를 쓰고 .cfg 에 불변식으로 추가하세요. 스펙에
\* 버그가 있으므로 이번 목표는 위반입니다. TLC 가 TypeOK 위반을 보고하면
\* speclings 가 통과시키고 반례를 보여줍니다. 버그는 고치지 않아도 됩니다.
\* 이런 반례를 읽고 그것이 보여주는 버그를 고치는 법은 다음 문제에서
\* 다룹니다.

Capacity == 3

VARIABLE cars

Init == cars = 0

Enter == /\ cars <= Capacity
         /\ cars' = cars + 1

Leave == /\ cars > 0
         /\ cars' = cars - 1

Next == Enter \/ Leave

TypeOK == ???

=============================================================================
