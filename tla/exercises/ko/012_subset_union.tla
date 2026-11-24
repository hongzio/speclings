-------------------------- MODULE 012_subset_union --------------------------
EXTENDS Integers, FiniteSets
\* speclings tla 012: SUBSET, UNION, Cardinality
\*
\*   SUBSET S          S 의 모든 부분집합의 집합
\*                     SUBSET {1, 2} = {{}, {1}, {2}, {1, 2}}
\*   UNION S           S 는 집합의 집합: 하나의 집합으로 합친다
\*                     UNION {{1}, {2, 3}} = {1, 2, 3}
\*   Cardinality(S)    유한 집합 S 의 원소 수 (FiniteSets 모듈)
\*
\* 원소가 n 개인 집합의 부분집합은 2^n 개입니다. 기억해 두세요. TLC 는
\* 여러분이 쓴 것을 모두 나열해야 하고, SUBSET 은 빠르게 커집니다.
\*
\* 빈칸을 채우세요.

ASSUME Cardinality({4, 5, 6}) = ???
ASSUME Cardinality(SUBSET {1, 2, 3}) = ???
ASSUME UNION {{1, 2}, {2, 3}, {}} = ???
ASSUME ({1} \in SUBSET {1, 2}) = ???
ASSUME SUBSET {} = ???

=============================================================================
