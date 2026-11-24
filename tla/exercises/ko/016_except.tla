----------------------------- MODULE 016_except -----------------------------
EXTENDS Integers
\* speclings tla 016: EXCEPT
\*
\* TLA+ 에서 값은 절대 바뀌지 않습니다. 함수를 수정하는 게 아니라, 몇몇
\* 키만 다른 새 함수를 씁니다.
\*
\*   [f EXCEPT ![k] = v]              f 에서 k 의 값만 v 로 바꾼 것
\*   [f EXCEPT ![k] = @ + 1]          @ 는 원래 값 f[k]
\*   [f EXCEPT ![a] = 1, ![b] = 2]    여러 키를 한 번에
\*
\* Go 로 말하면 g := clone(f); g[k] = v 입니다. f 자체는 그대로입니다.
\*
\* Move(b, from, to, amt) 는 잔고 함수 b 에서 계좌 from 의 amt 를 계좌
\* to 로 옮긴 결과입니다. EXCEPT 하나로 쓰세요.

bal == [a \in {"alice", "bob"} |-> 10]

Move(b, from, to, amt) == ???

ASSUME Move(bal, "alice", "bob", 3)["alice"] = 7
ASSUME Move(bal, "alice", "bob", 3)["bob"] = 13
ASSUME DOMAIN Move(bal, "alice", "bob", 3) = {"alice", "bob"}
ASSUME bal["alice"] = 10
ASSUME [bal EXCEPT !["bob"] = @ * 2]["bob"] = ???

=============================================================================
