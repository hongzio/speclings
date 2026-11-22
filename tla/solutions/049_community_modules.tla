----------------------- MODULE 049_community_modules ------------------------
EXTENDS Integers, FiniteSets, Functions
\* tlings 049: CommunityModules
\*
\* The standard modules are small on purpose. The TLA+ CommunityModules add
\* many everyday operators, and tlings puts them on TLC's path, so you can
\* EXTENDS them like standard modules. A few of them:
\*
\*   Functions       SumFunction(f), Range(f), Restrict(f, S), ...
\*   FiniteSetsExt   SumSet(S), MapThenSumSet(Op, S), Max(S), Min(S), ...
\*   SequencesExt    ToSet(s), Reverse(s), SetToSeq(S), ...
\*
\* SumFunction(f) adds up the values of a function whose values are
\* numbers: SumFunction([x \in {"a", "b"} |-> 3]) = 6. No RECURSIVE needed
\* (019).
\*
\* This is the fixed transfer from 037. Money is neither created nor
\* destroyed: the balances plus the amounts in flight (withdrawn but not
\* yet deposited) always add up to what the bank started with. Write Money
\* and InFlight; the ASSUMEs test them, and the .cfg checks TotalConserved.

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

\* the total of all balances in bal
Money(bal) == SumFunction(bal)

\* the total amount in flight: a worker w whose pc is "deposit" has
\* withdrawn a[w].amt and not deposited it yet
InFlight(p, a) == SumFunction([w \in DOMAIN p |-> IF p[w] = "deposit" THEN a[w].amt ELSE 0])

ASSUME Money([x \in {"a", "b"} |-> 3]) = 6
ASSUME InFlight([w \in {"w1", "w2"} |-> "deposit"], [w \in {"w1", "w2"} |-> [amt |-> 2]]) = 4
ASSUME InFlight([w \in {"w1", "w2"} |-> IF w = "w1" THEN "deposit" ELSE "done"],
                [w \in {"w1", "w2"} |-> [amt |-> 2]]) = 2

TotalConserved == Money(balance) + InFlight(pc, args) = InitBalance * Cardinality(Accounts)

=============================================================================
