---------------------------- MODULE 017_records -----------------------------
EXTENDS Integers, FiniteSets
\* tlings 017: 레코드
\*
\*   [from |-> "alice", amt |-> 3]    레코드. Go 의 struct 값과 비슷
\*   r.amt                            필드
\*   [r EXCEPT !.amt = 5]             필드 하나만 바꾼 r
\*   [from : S, amt : T]              from 은 S 에, amt 는 T 에 있는
\*                                    모든 레코드의 집합
\*
\* 레코드는 정의역이 문자열 집합인 함수입니다. r.amt 는 r["amt"] 이고,
\* DOMAIN r 은 필드 이름의 집합입니다. 그래서 EXCEPT 와 DOMAIN 이
\* 레코드에도 통합니다.
\*
\* 빈칸을 채우세요.

r == [from |-> "alice", to |-> "bob", amt |-> 3]

ASSUME r.to = ???
ASSUME r["amt"] = ???
ASSUME DOMAIN r = ???
ASSUME [r EXCEPT !.amt = @ + 1].amt = ???
ASSUME Cardinality([kind : {"deposit", "withdraw"}, amt : 1..3]) = ???

=============================================================================
