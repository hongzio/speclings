---------------------------- MODULE 041_symmetry ----------------------------
EXTENDS Integers, FiniteSets, TLC
\* speclings tla 041: 대칭
\*
\* worker 가 셋이면 035 의 mutex 카운터는 distinct state 가 61 개입니다.
\* 그중 많은 것이 worker 이름만 바꾼 같은 상황입니다. "w1 이 lock 을 쥐었다"
\* 와 "w2 가 lock 을 쥐었다" 는 똑같이 동작합니다. 스펙 어디에서도 w1 을
\* w2 와 다르게 다루지 않기 때문입니다.
\*
\* TLC 는 이것을 활용할 수 있습니다. worker 의 순열(permutation)을 대칭
\* 집합으로 선언하면, TLC 는 이름만 바꾼 상태들의 묶음마다 하나만 남깁니다.
\*
\*   Symm == Permutations(Workers)     Permutations 는 TLC 모듈에 있음
\*   SYMMETRY Symm                     .cfg 에
\*
\* worker 가 정체성 외에는 아무 의미가 없는 model value 라서 가능한
\* 일입니다. 상태 수가 61 에서 13 으로 줄고, worker 가 많을수록 절약이 빠르게
\* 커집니다. Correct 같은 불변식에는 대칭을 써도 안전합니다. Part 4 의
\* liveness 속성에서는 버그를 가릴 수 있으니 그때는 쓰지 마세요.
\*
\* Symm 을 정의하고 .cfg 에 대칭을 추가하세요.

CONSTANTS Workers, NoOne

VARIABLES counter, tmp, pc, lock

vars == <<counter, tmp, pc, lock>>

Init == /\ counter = 0
        /\ tmp = [w \in Workers |-> 0]
        /\ pc = [w \in Workers |-> "lock"]
        /\ lock = NoOne

Lock(w) == /\ pc[w] = "lock"
           /\ lock = NoOne
           /\ lock' = w
           /\ pc' = [pc EXCEPT ![w] = "read"]
           /\ UNCHANGED <<counter, tmp>>

Read(w) == /\ pc[w] = "read"
           /\ tmp' = [tmp EXCEPT ![w] = counter]
           /\ pc' = [pc EXCEPT ![w] = "write"]
           /\ UNCHANGED <<counter, lock>>

Write(w) == /\ pc[w] = "write"
            /\ counter' = tmp[w] + 1
            /\ pc' = [pc EXCEPT ![w] = "unlock"]
            /\ UNCHANGED <<tmp, lock>>

Unlock(w) == /\ pc[w] = "unlock"
             /\ lock' = NoOne
             /\ pc' = [pc EXCEPT ![w] = "done"]
             /\ UNCHANGED <<counter, tmp>>

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == \/ \E w \in Workers : Lock(w) \/ Read(w) \/ Write(w) \/ Unlock(w)
        \/ Terminating

Spec == Init /\ [][Next]_vars

Correct == (\A w \in Workers : pc[w] = "done") => counter = Cardinality(Workers)

Symm == ???

=============================================================================
