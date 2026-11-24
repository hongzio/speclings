----------------------------- MODULE 037_quiz3 ------------------------------
EXTENDS Integers
\* tlings 037: quiz
\*
\* A bank transfer in Go. Every method locks the bank's mutex, so there is
\* no data race, and go run -race reports nothing:
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
\* The spec below models it with one action per locked method. Two
\* goroutines make one transfer each. Init picks their arguments from
\* [Workers -> Requests] (015, 020), so TLC tries every combination. TLC
\* finds NoOverdraft violated.
\*
\* Read the trace to see how an account goes negative. Then fix the spec
\* the way you would fix the Go code: the check and the withdrawal must be
\* one step, under one lock. Replace Check and Withdraw with a single
\* action CheckAndWithdraw(w), and update Next.
\*
\* See it in Go, before and after:
\*
\*   go run -race ./go/037_transfer
\*   go run -race ./go/037_transfer -fix

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

=============================================================================
