--------------------------- MODULE 030_constraint ---------------------------
EXTENDS Integers
\* tlings 030: infinite state spaces
\*
\* TLC lists every reachable state, so there must be finitely many. This
\* sender numbers its messages and never stops, so its state space is
\* infinite and TLC would run forever. tlings gives up after 30 seconds.
\*
\* There are two ways out:
\*
\*   - bound the spec itself, for example with a guard sent < Max
\*   - keep the spec, and limit only what TLC explores with a state
\*     constraint in the .cfg:
\*
\*       CONSTRAINT SentBound
\*
\*     TLC then skips the states where SentBound is FALSE, and does not
\*     look beyond them.
\*
\* The second keeps the spec honest: the real system has no limit, only the
\* check does. Write SentBound, "at most 5 messages have been sent", and add
\* the constraint to the .cfg.

VARIABLE sent    \* how many messages have been sent

Init == sent = 0

Send == sent' = sent + 1

Next == Send

=============================================================================
