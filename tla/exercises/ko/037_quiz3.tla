----------------------------- MODULE 037_quiz3 ------------------------------
EXTENDS Integers
\* tlings 037: 퀴즈
\*
\* Go 로 쓴 계좌 이체입니다. 모든 메서드가 은행의 mutex 를 잡으므로 data
\* race 는 없고, go run -race 도 아무것도 보고하지 않습니다.
\*
\*   func (b *Bank) Transfer(from, to string, amt int) error {
\*       if b.Balance(from) < amt {          // check
\*           return ErrInsufficientFunds
\*       }
\*       b.withdraw(from, amt)               // withdraw
\*       b.deposit(to, amt)                  // deposit
\*       return nil
\*   }                                       // done
\*
\* 아래 스펙은 lock 을 잡는 메서드마다 action 하나로 이것을 모델링합니다.
\* goroutine 두 개가 각각 이체를 한 번씩 합니다. Init 이 인자를
\* [Workers -> Requests] 에서 고르므로 (015, 020) TLC 는 모든 조합을
\* 시도합니다. TLC 가 NoOverdraft 위반을 찾습니다.
\*
\* trace 를 읽고 계좌가 어떻게 음수가 되는지 보세요. 그다음 Go 코드를 고칠
\* 방식대로 스펙을 고치세요. 확인과 출금은 하나의 lock 아래에서 한 step
\* 이어야 합니다. Check 와 Withdraw 를 action 하나 CheckAndWithdraw(w) 로
\* 바꾸고, Next 도 고치세요.
\*
\* Go 에서 고치기 전과 후를 보세요.
\*
\*   go run -race ./tla/go/037_transfer
\*   go run -race ./tla/go/037_transfer -fix

CONSTANTS Accounts, Workers, InitBalance, MaxAmount

VARIABLES balance, pc, args

vars == <<balance, pc, args>>

Requests == {r \in [from : Accounts, to : Accounts, amt : 1..MaxAmount] : r.from # r.to}

Init == /\ balance = [a \in Accounts |-> InitBalance]
        /\ args \in [Workers -> Requests]
        /\ pc = [w \in Workers |-> "check"]

Check(w) == /\ pc[w] = "check"
            /\ pc' = [pc EXCEPT ![w] = IF balance[args[w].from] < args[w].amt
                                          THEN "done"
                                          ELSE "withdraw"]
            /\ UNCHANGED <<balance, args>>

Withdraw(w) == /\ pc[w] = "withdraw"
               /\ balance' = [balance EXCEPT ![args[w].from] = @ - args[w].amt]
               /\ pc' = [pc EXCEPT ![w] = "deposit"]
               /\ UNCHANGED args

Deposit(w) == /\ pc[w] = "deposit"
              /\ balance' = [balance EXCEPT ![args[w].to] = @ + args[w].amt]
              /\ pc' = [pc EXCEPT ![w] = "done"]
              /\ UNCHANGED args

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == \/ \E w \in Workers : Check(w) \/ Withdraw(w) \/ Deposit(w)
        \/ Terminating

Spec == Init /\ [][Next]_vars

NoOverdraft == \A a \in Accounts : balance[a] >= 0

=============================================================================
