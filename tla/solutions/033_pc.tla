------------------------------- MODULE 033_pc -------------------------------
EXTENDS Integers
\* speclings tla 033: the program counter
\*
\* From here on, specs model Go code. Start with one goroutine:
\*
\*   func incr() {
\*       tmp := counter       // read
\*       counter = tmp + 1    // write
\*   }                        // done
\*
\* TLA+ has no statements and no "next line", so the spec keeps the
\* position in the code in a variable of its own, conventionally called pc
\* (program counter). Each line becomes an action that is enabled only when
\* pc points at it, does what the line does, and moves pc on:
\*
\*   Read == /\ pc = "read"        only when the next line is "read"
\*           /\ tmp' = counter     what the line does
\*           /\ pc' = "write"      move on to the next line
\*           /\ UNCHANGED counter
\*
\* Local variables like tmp become variables of the spec too.
\*
\* Write the action for the second line. Correct, listed in the .cfg,
\* checks that incr really adds 1.

VARIABLES counter, tmp, pc

vars == <<counter, tmp, pc>>

Init == /\ counter = 0
        /\ tmp = 0
        /\ pc = "read"

Read == /\ pc = "read"
        /\ tmp' = counter
        /\ pc' = "write"
        /\ UNCHANGED counter

Write == /\ pc = "write"
         /\ counter' = tmp + 1
         /\ pc' = "done"
         /\ UNCHANGED tmp

Terminating == /\ pc = "done"
               /\ UNCHANGED vars

Next == Read \/ Write \/ Terminating

Spec == Init /\ [][Next]_vars

\* once incr has returned, counter is 1
Correct == pc = "done" => counter = 1

=============================================================================
