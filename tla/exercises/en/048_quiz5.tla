----------------------------- MODULE 048_quiz5 ------------------------------
\* tlings 048: quiz
\*
\* Two goroutines each need two mutexes, a and b. To avoid a deadlock,
\* they take the first one, then try the second with TryLock, and if it is
\* taken they release the first and start over:
\*
\*   for {
\*       first.Lock()                // first
\*       if second.TryLock() {       // second
\*           break
\*       }
\*       first.Unlock()              // back off and retry
\*   }
\*   work()                          // work, then unlock both
\*                                   // done
\*
\* w1 takes a then b; w2 takes b then a. There is no deadlock, but there
\* can be a livelock: both keep taking steps and backing off forever, and
\* neither ever finishes.
\*
\*   1. Write Termination, "eventually every goroutine is done", and add it
\*      to the .cfg as a property.
\*   2. TLC finds it violated. Read the loop in the counterexample.
\*   3. Fix it the standard way: every goroutine takes the mutexes in the
\*      same order, a then b. Change First and Second.

CONSTANT NoOne

Workers == {"w1", "w2"}
Locks == {"a", "b"}

\* the mutex each goroutine takes first, and the one it tries second
First == [w \in Workers |-> IF w = "w1" THEN "a" ELSE "b"]
Second == [w \in Workers |-> IF w = "w1" THEN "b" ELSE "a"]

VARIABLES pc, owner    \* owner[l]: the goroutine holding mutex l, or NoOne

vars == <<pc, owner>>

Init == /\ pc = [w \in Workers |-> "first"]
        /\ owner = [l \in Locks |-> NoOne]

LockFirst(w) == /\ pc[w] = "first"
                /\ owner[First[w]] = NoOne
                /\ owner' = [owner EXCEPT ![First[w]] = w]
                /\ pc' = [pc EXCEPT ![w] = "second"]

TrySecond(w) == /\ pc[w] = "second"
                /\ IF owner[Second[w]] = NoOne
                      THEN /\ owner' = [owner EXCEPT ![Second[w]] = w]
                           /\ pc' = [pc EXCEPT ![w] = "work"]
                      ELSE /\ owner' = [owner EXCEPT ![First[w]] = NoOne]
                           /\ pc' = [pc EXCEPT ![w] = "first"]

Finish(w) == /\ pc[w] = "work"
             /\ owner' = [l \in Locks |-> IF owner[l] = w THEN NoOne ELSE owner[l]]
             /\ pc' = [pc EXCEPT ![w] = "done"]

Step(w) == LockFirst(w) \/ TrySecond(w) \/ Finish(w)

Terminating == /\ \A w \in Workers : pc[w] = "done"
               /\ UNCHANGED vars

Next == (\E w \in Workers : Step(w)) \/ Terminating

Spec == Init /\ [][Next]_vars /\ \A w \in Workers : WF_vars(Step(w))

Termination == ???

=============================================================================
