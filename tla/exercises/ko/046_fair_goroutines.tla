------------------------ MODULE 046_fair_goroutines -------------------------
EXTENDS Integers
\* speclings tla 046: goroutine 마다의 공정성
\*
\* goroutine 두 개가 각자 0, 1, 2, 0, 1, 2, ... 를 세며 영원히 돕니다.
\* Progress 는 둘 다 계속 나아간다는 뜻입니다. 모든 worker 에 대해 count
\* 가 2 가 되는 일이 계속해서 일어난다 ([]<> 는 "무한히 자주").
\*
\* Spec 에는 WF_vars(Next) 가 있는데도 TLC 가 Progress 위반을 찾습니다.
\* 반례를 읽어 보세요. "Back to state" 로 끝나는데, 이것은 영원히 반복되는
\* 고리를 뜻하고, 그 고리에서는 goroutine 하나만 실행됩니다. 언제나 step 을
\* 밟는 Next 에게는 공정하지만, 다른 goroutine 에게는 공정하지 않습니다.
\*
\* 스케줄러가 실행 가능한 모든 goroutine 을 결국 실행한다고 말하려면, 각
\* goroutine 자신의 action 에 공정성을 줍니다.
\*
\*   \A w \in Workers : WF_vars(Tick(w))
\*
\* Spec 의 WF_vars(Next) 를 이것으로 바꾸세요.

CONSTANT Workers

VARIABLE count

vars == <<count>>

Init == count = [w \in Workers |-> 0]

Tick(w) == count' = [count EXCEPT ![w] = (@ + 1) % 3]

Next == \E w \in Workers : Tick(w)

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

Progress == \A w \in Workers : []<>(count[w] = 2)

=============================================================================
