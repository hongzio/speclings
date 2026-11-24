----------------------- MODULE 049_community_modules ------------------------
EXTENDS Integers, FiniteSets, Functions
\* tlings 049: CommunityModules
\*
\* 표준 모듈은 일부러 작게 만들어져 있습니다. TLA+ CommunityModules 는 자주
\* 쓰는 연산자를 많이 더해 주고, tlings 는 이것을 TLC 의 경로에 넣어 두었으니
\* 표준 모듈처럼 EXTENDS 하면 됩니다. 그중 몇 가지:
\*
\*   Functions       SumFunction(f), Range(f), Restrict(f, S), ...
\*   FiniteSetsExt   SumSet(S), MapThenSumSet(Op, S), Max(S), Min(S), ...
\*   SequencesExt    ToSet(s), Reverse(s), SetToSeq(S), ...
\*
\* SumFunction(f) 는 값이 수인 함수의 값을 모두 더합니다:
\* SumFunction([x \in {"a", "b"} |-> 3]) = 6. RECURSIVE (019) 가 필요 없습니다.
\*
\* 037 의 고친 이체입니다. 돈은 생기지도 사라지지도 않습니다. 잔고와 이체
\* 중인 금액(출금했지만 아직 입금하지 않은 금액)을 더하면 언제나 은행이
\* 처음 가진 돈과 같습니다. Money 와 InFlight 를 쓰세요. ASSUME 이 둘을
\* 시험하고, .cfg 가 TotalConserved 를 검사합니다.

CONSTANTS Accounts, Workers, InitBalance, MaxAmount

VARIABLES balance, pc, args

vars == <<balance, pc, args>>

Requests == {r \in [from : Accounts, to : Accounts, amt : 1..MaxAmount] : r.from # r.to}

Init == /\ balance = [a \in Accounts |-> InitBalance]
        /\ args \in [Workers -> Requests]
        /\ pc = [w \in Workers |-> "check"]

CheckAndWithdraw(w) == /\ pc[w] = "check"
                       /\ IF balance[args[w].from] < args[w].amt
                             THEN /\ pc' = [pc EXCEPT ![w] = "done"]
                                  /\ UNCHANGED balance
                             ELSE /\ balance' = [balance EXCEPT ![args[w].from] = @ - args[w].amt]
                                  /\ pc' = [pc EXCEPT ![w] = "deposit"]
                       /\ UNCHANGED args

Deposit(w) == /\ pc[w] = "deposit"
              /\ balance' = [balance EXCEPT ![args[w].to] = @ + args[w].amt]
              /\ pc' = [pc EXCEPT ![w] = "done"]
              /\ UNCHANGED args

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == \/ \E w \in Workers : CheckAndWithdraw(w) \/ Deposit(w)
        \/ Terminating

Spec == Init /\ [][Next]_vars

NoOverdraft == \A a \in Accounts : balance[a] >= 0

\* bal 의 모든 잔고의 합
Money(bal) == ???

\* 이체 중인 금액의 합: pc 가 "deposit" 인 worker w 는 a[w].amt 를
\* 출금했고 아직 입금하지 않았다
InFlight(p, a) == ???

ASSUME Money([x \in {"a", "b"} |-> 3]) = 6
ASSUME InFlight([w \in {"w1", "w2"} |-> "deposit"], [w \in {"w1", "w2"} |-> [amt |-> 2]]) = 4
ASSUME InFlight([w \in {"w1", "w2"} |-> IF w = "w1" THEN "deposit" ELSE "done"],
                [w \in {"w1", "w2"} |-> [amt |-> 2]]) = 2

TotalConserved == Money(balance) + InFlight(pc, args) = InitBalance * Cardinality(Accounts)

=============================================================================
