----------------------------- MODULE 002_extends -----------------------------
\* tlings 002: EXTENDS
\*
\* 숫자 1, 2, 3 은 그냥 쓸 수 있지만, + - * < 같은 연산자는 TLA+ 언어에
\* 들어 있지 않습니다. 표준 모듈에 정의되어 있어서, 쓰려면 EXTENDS 로
\* 가져와야 합니다. EXTENDS 는 모듈 헤더 바로 다음 줄에 씁니다.
\*
\*   EXTENDS Naturals
\*   EXTENDS Naturals, Sequences      여러 개면 쉼표로
\*
\* 자주 쓰는 표준 모듈:
\*
\*   Naturals     Nat  + - * \div %  ..  < <= > >=
\*   Integers     Naturals 전부 + Int 와 음수
\*   Sequences    Seq  Len  Append  Head  Tail  \o
\*   FiniteSets   Cardinality  IsFiniteSet
\*   TLC          Print  PrintT  Assert 같은 TLC 전용 도구
\*
\* 아래 줄은 "Two 를 1 + 1 로 정의한다" 는 뜻입니다. == 는 정의이고,
\* 007 에서 자세히 다룹니다. 지금은 + 가 어디서 오는지만 보세요.

Two == 1 + 1

=============================================================================
