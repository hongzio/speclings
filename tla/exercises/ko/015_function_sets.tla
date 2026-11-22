------------------------- MODULE 015_function_sets --------------------------
EXTENDS Integers, FiniteSets
\* tlings 015: 함수의 집합
\*
\*   [S -> T]    정의역이 S 이고 값이 T 에 있는 모든 함수의 집합
\*
\* [{"a", "b"} -> {0, 1}] 의 원소는 4 개입니다. "a" 와 "b" 에 0 이나 1 을
\* 주는 방법마다 하나씩입니다. 일반적으로 [S -> T] 의 원소는 |T|^|S| 개입니다.
\*
\* [S -> T] 는 그냥 집합입니다. 스펙에서는 \in 과 함께, 흔히 타입 검사로
\* 씁니다.
\*
\*   balance \in [Accounts -> Int]    "balance 는 계좌에서 정수로 가는
\*                                     함수다"
\*
\* 빈칸을 채우세요.

Flags == [{"a", "b"} -> BOOLEAN]

ASSUME [x \in {"a", "b"} |-> TRUE] \in Flags
ASSUME Cardinality(Flags) = ???
ASSUME ([x \in {"a"} |-> TRUE] \in Flags) = ???
ASSUME Cardinality([1..3 -> 1..2]) = ???

=============================================================================
