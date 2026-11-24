--------------------------- MODULE 019_recursion ----------------------------
EXTENDS Integers
\* speclings tla 019: RECURSIVE
\*
\* 이름은 정의보다 아래에서만 쓸 수 있으므로(007), 정의 안에서 자기 이름을
\* 쓸 수 없습니다. 재귀 연산자를 쓰려면 먼저 선언합니다.
\*
\*   RECURSIVE Fact(_)            매개변수 하나마다 _ 하나
\*   Fact(n) == IF n = 0 THEN 1 ELSE n * Fact(n - 1)
\*
\* RECURSIVE A(_), B(_, _) 처럼 여러 개를 한 번에 선언할 수 있습니다.
\*
\* 반복문이 없으므로, 집합을 접으려면(fold) 아래 Sum 처럼 CHOOSE 로 원소
\* 하나를 꺼내고 나머지에 대해 재귀합니다. Product 를 같은 방식으로
\* 쓰세요(공집합의 곱은 1). 그다음 TLC 가 둘 다 받아들이게 하세요.

Sum(S) == IF S = {} THEN 0
          ELSE LET x == CHOOSE y \in S : TRUE
               IN  x + Sum(S \ {x})

Product(S) == ???

ASSUME Sum({}) = 0
ASSUME Sum(1..100) = 5050
ASSUME Product({}) = 1
ASSUME Product({2, 3, 4}) = 24

=============================================================================
