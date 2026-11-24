----------------------------- MODULE 032_quiz2 ------------------------------
EXTENDS Integers
\* tlings 032: 퀴즈
\*
\* 유명한 물통 퍼즐입니다. 3 갤런 통, 5 갤런 통, 수도꼭지가 있습니다. 통을
\* 가득 채우거나, 비우거나, 한 통을 다른 통에 부을 수 있습니다. 부을 때는
\* 앞의 통이 비거나 뒤의 통이 찰 때까지 붓습니다. 정확히 4 갤런을 잴 수
\* 있을까요?
\*
\* TLC 가 풀게 하세요. "큰 통에는 결코 4 갤런이 들어 있지 않다" 는 불변식을
\* 쓰고 검사합니다. 퍼즐을 풀 수 있다면 TLC 는 그 불변식의 위반을 보고하고,
\* 그 반례가 가장 짧은 풀이입니다. 그러면 tlings 가 통과시킵니다.
\*
\* 먼저 붓는 action 두 개를 완성하세요. Min(a, b) 는 a 와 b 중 작은 값입니다.

Min(a, b) == IF a < b THEN a ELSE b

VARIABLES small, big

Init == small = 0 /\ big = 0

FillSmall  == small' = 3 /\ UNCHANGED big
FillBig    == big' = 5 /\ UNCHANGED small
EmptySmall == small' = 0 /\ UNCHANGED big
EmptyBig   == big' = 0 /\ UNCHANGED small

\* 작은 통을 큰 통에 붓는다
SmallToBig == ???

\* 큰 통을 작은 통에 붓는다
BigToSmall == ???

Next == \/ FillSmall
        \/ FillBig
        \/ EmptySmall
        \/ EmptyBig
        \/ SmallToBig
        \/ BigToSmall

TypeOK == small \in 0..3 /\ big \in 0..5

NotFour == ???

=============================================================================
