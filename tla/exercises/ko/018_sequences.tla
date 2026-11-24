--------------------------- MODULE 018_sequences ----------------------------
EXTENDS Integers, Sequences
\* speclings tla 018: 튜플과 시퀀스
\*
\*   <<1, 2, 3>>        튜플, 시퀀스라고도 함. 인덱스는 1 부터
\*   s[i]               i 번째 원소
\*   Len(s)             길이
\*   Append(s, e)       s 끝에 e 를 붙인 것
\*   Head(s)            첫 원소
\*   Tail(s)            첫 원소를 뺀 나머지
\*   s \o t             s 뒤에 t 를 이은 것
\*   SubSeq(s, m, n)    m 번째부터 n 번째까지
\*   Seq(S)             S 의 원소로 된 모든 시퀀스의 집합 (무한)
\*
\* <<...>> 와 s[i] 를 빼면 모두 Sequences 모듈에 있습니다.
\*
\* 튜플은 정의역이 1..n 인 함수입니다. 그래서 DOMAIN <<"a", "b">> = 1..2
\* 입니다. TLC 는 정의역이 1..n 인 함수를 모두 튜플로 출력합니다.
\*
\* 버퍼가 있는 Go 채널 같은 FIFO 큐는 시퀀스입니다. 보낼 때는 Append,
\* 받을 때는 Head 와 Tail 을 씁니다. Send 와 Receive 를 쓰세요.

\* m 을 보낸 뒤의 queue
Send(queue, m) == ???

\* 메시지 하나를 받은 뒤의 queue
Receive(queue) == ???

ASSUME Send(<<>>, "a") = <<"a">>
ASSUME Send(<<"a">>, "b") = <<"a", "b">>
ASSUME Receive(<<"a", "b">>) = <<"b">>
ASSUME Receive(Send(<<"a">>, "b")) = <<"b">>
ASSUME Len(<<>>) = ???
ASSUME DOMAIN <<"x", "y", "z">> = ???

=============================================================================
