# speclings: the TLA+ track

**English** | [한국어](README.ko.md) · [speclings](../README.md)

Learn TLA+ and TLC by fixing small, broken TLA+ specs one at a time.

> **Work in progress:** there are 53 exercises so far (Part 0: tools, Part 1: values, Part 2: state machines, Part 3: concurrency, Part 4: temporal properties, Part 5: beyond the basics), and more are being added.

Run it with `speclings tla`. Setup and commands are in the [main README](../README.md).

When a check passes, speclings shows TLC's output only with `-v`, if your file uses `Print` or `PrintT`, or if the goal was a counterexample (a violation or a deadlock), so that you can read it.

## How an exercise passes

| Expected | Passes when |
|---|---|
| no errors | TLC finishes with no errors. Every `ASSUME` of the original must still be in your file (fill in `???`, but do not remove or comment out lines); you may add your own |
| no errors, N distinct states | the above, and TLC explores exactly N distinct states |
| invariant X violated (counterexample length N) | TLC finds a violation of X with a counterexample of N states |
| deadlock (counterexample length N) | TLC finds a deadlock with a counterexample of N states |
| property X violated | TLC finds a violation of the property X. The counterexample length is not checked: for liveness, TLC's counterexamples are not the shortest and can differ between runs |

Why count states: if you "fix" a spec by deleting it (for example `Next == FALSE`), every invariant holds.
With BFS and a single worker, the state count and the counterexample length are always the same, so they make reliable expectations.

Each TLC run is stopped after 30 seconds. Exercises finish in about a second, so a spec that runs longer most likely has an infinite state space.

## Go programs

Parts 3 and 5 model real Go code. The programs are in `go/`; run them from the repository root as the exercises say, e.g. `go run -race ./tla/go/034_lost_update`.

## For authors

`speclings verify tla` checks that the original in every language fails in the intended way: exit code, an output phrase and the line it points to.

On top of the [rules for every track](../README.md#for-authors):

- Every `ASSUME` of the original must stay in the learner's file, or deleting it would "pass" the check.
  speclings compares lines ignoring whitespace, with `???` matching anything; learners may add their own.
  The `ASSUME` line containing `Broken.At` only has to keep that snippet, so an exercise can ask learners to correct a value there.
- An exercise that INSTANCEs or EXTENDs a helper module lists it in `Modules`. speclings copies helper modules to `work/tla/` with the exercise, and `verify` checks that their code matches across languages too. Prefix their names with the exercise number (`050_AtomicCounter`), because `work/tla/` is shared.
- Add `solutions/<Name>.cfg` only if the fix is in the `.cfg`; otherwise the solution is checked with the original's.

## Beyond this track

- **ALIAS**: in the `.cfg`, `ALIAS View` makes TLC print the record `View` in each state of a counterexample instead of the raw variables (tip in 051).
- **Simulation**: `tlc -simulate num=1000 -depth 100 Spec.tla` checks 1000 random behaviors of up to 100 steps instead of all of them, for state spaces too large to explore. Without `num`, it runs until you stop it.
- **[Apalache](https://github.com/apalache-mc/apalache)**: a symbolic model checker for TLA+ that uses an SMT solver and type annotations. It can check specs with large or unbounded data that TLC cannot enumerate.
- **Further reading**: Leslie Lamport's [Specifying Systems](https://lamport.azurewebsites.net/tla/book.html) and Hillel Wayne's [Learn TLA+](https://learntla.com).
