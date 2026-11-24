------------------------- MODULE 027_counterexample -------------------------
EXTENDS Integers
\* speclings tla 027: 반례 읽기
\*
\* 불변식이 깨지면 TLC 는 나쁜 상태에 이르는 behavior 를 step 마다 상태
\* 하나씩 출력합니다.
\*
\*   State 1: <Initial predicate>
\*   /\ ew = "red"
\*   /\ ns = "green"
\*
\*   State 2: <NsTurn line ..., col ... of module 027_counterexample>
\*   ...
\*
\* 첫 상태를 빼면 각 상태에는 그 상태를 만든 action 이 표시됩니다. 나쁜
\* 상태에서 거꾸로 trace 를 읽으면, 어떤 action 이 밟지 말아야 할 step 을
\* 밟았는지 대개 보입니다.
\*
\* 교차로를 신호등 두 개가 지킵니다: 남북(ns)과 동서(ew). 각각 초록 ->
\* 노랑 -> 빨강 -> 초록 순으로 바뀝니다. 신호등은 다른 쪽이 빨간불일 때만
\* 초록불이 될 수 있어서, 언제나 적어도 하나는 빨간불입니다 (Safe). TLC 가
\* Safe 위반을 찾았습니다. trace 를 읽고 버그를 찾아 고치세요.

VARIABLES ns, ew

Colors == {"green", "yellow", "red"}

After(c) == CASE c = "green"  -> "yellow"
              [] c = "yellow" -> "red"
              [] c = "red"    -> "green"

Init == ns = "green" /\ ew = "red"

NsTurn == /\ ns = "red" => ew = "red"
          /\ ns' = After(ns)
          /\ UNCHANGED ew

EwTurn == /\ ew = "red" => ns # "green"
          /\ ew' = After(ew)
          /\ UNCHANGED ns

Next == NsTurn \/ EwTurn

TypeOK == ns \in Colors /\ ew \in Colors

Safe == ns = "red" \/ ew = "red"

=============================================================================
