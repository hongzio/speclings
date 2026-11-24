----------------------------- MODULE 020_quiz1 ------------------------------
EXTENDS Integers, FiniteSets
\* speclings tla 020: 퀴즈
\*
\* goroutine 두 개가 각각 Transfer(from, to, amt) 를 한 번씩 호출합니다.
\* 일어날 수 있는 모든 경우를 검사하려면, 스펙에는 먼저 가능한 모든
\* 호출의 집합이 필요합니다.
\*
\* 요청은 from 과 to (서로 다른 두 계좌), amt (1 부터 MaxAmount 까지의
\* 금액) 필드를 가진 레코드입니다.
\*
\*   Requests       가능한 모든 요청의 집합
\*   Assignments    각 worker 에게 요청 하나씩을 주는 모든 방법의 집합
\*
\* 그다음 각각 몇 개인지 계산하고, TLC 로 계산을 확인하세요.

Accounts == {"alice", "bob", "carol"}
Workers == {"w1", "w2"}
MaxAmount == 2

Requests == ???

Assignments == ???

ASSUME [from |-> "alice", to |-> "bob", amt |-> 2] \in Requests
ASSUME [from |-> "alice", to |-> "alice", amt |-> 1] \notin Requests
ASSUME [from |-> "alice", to |-> "bob", amt |-> 0] \notin Requests
ASSUME [w \in Workers |-> [from |-> "bob", to |-> "carol", amt |-> 1]] \in Assignments
ASSUME Cardinality(Requests) = ???
ASSUME Cardinality(Assignments) = ???

=============================================================================
