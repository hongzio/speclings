---------------------------- MODULE 028_deadlock ----------------------------
EXTENDS Integers
\* tlings 028: deadlock
\*
\* A deadlock is a reachable state in which no step is possible. TLC looks
\* for deadlocks by default, because they are usually bugs: Go's "fatal
\* error: all goroutines are asleep - deadlock!" is one.
\*
\* But a system that is meant to finish, like a function that returns, also
\* ends in a state with no further step. Tell TLC that this is intended by
\* allowing a step that changes nothing once the work is done:
\*
\*   Terminating == /\ <the work is done>
\*                  /\ UNCHANGED vars
\*
\* vars is the conventional name for the tuple of all variables.
\* (Running tlc with -deadlock turns the check off, but then real deadlocks
\* go unnoticed too.)
\*
\* Run tlings and read the deadlock TLC reports. Then write Terminating and
\* add it to Next.

VARIABLES received, status

vars == <<received, status>>

Init == received = 0 /\ status = "downloading"

Get == /\ status = "downloading"
       /\ received < 3
       /\ received' = received + 1
       /\ UNCHANGED status

Finish == /\ status = "downloading"
          /\ received = 3
          /\ status' = "done"
          /\ UNCHANGED received

Terminating == /\ status = "done"
               /\ UNCHANGED vars

Next == Get \/ Finish \/ Terminating

=============================================================================
