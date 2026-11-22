# tlings

**English** | [한국어](README.ko.md)

Learn TLA+ and TLC by fixing small, broken TLA+ specs one at a time.
Modeled after [ziglings](https://codeberg.org/ziglings/exercises/).

> **Work in progress:** there are 48 exercises so far (Part 0: tools, Part 1: values, Part 2: state machines, Part 3: concurrency, Part 4: temporal properties), and more are being added.

## Getting started

You need [mise](https://mise.jdx.dev/) on macOS or Linux. It installs everything else.

```sh
git clone https://github.com/hongzio/tlings.git && cd tlings
mise trust         # allow this directory's mise.toml
mise install       # Java, Go, tla2tools, CommunityModules, Apalache
tlings             # start from the first exercise (English)
tlings -lang ko    # or pick a language first; it is remembered
```

`tlings` is `bin/tlings`. mise puts `bin/` on your PATH when it is
[activated in your shell](https://mise.jdx.dev/getting-started.html#activate-mise);
otherwise run `mise exec -- tlings`.
It rebuilds the runner on every run (cached), so new exercises never require a reinstall.

You solve exercises in `work/`. When you reach an exercise, tlings copies it there in your language.
The originals in `exercises/` stay untouched.

## Commands

| Command | What it does |
|---|---|
| `tlings` | Check exercises in order from where you left off; stop at the first failure |
| `tlings -watch` | Same, and check again whenever you save a file in `work/` |
| `tlings -lang ko` | Switch language. Exercises already in `work/` keep their language |
| `tlings -n 3` | Check exercise 3 only (progress is not updated) |
| `tlings -s 3` | Check in order starting from exercise 3 |
| `tlings -restore 3` | Restore exercise 3 to its original state (your file is kept as `.bak`) |
| `tlings -hint` | Show a hint for the current exercise (`-hint -n 3`: for exercise 3) |
| `tlings -v` | Also show TLC's output when a check passes |
| `tlings -reset` | Clear progress |

On failure, tlings shows TLC's output **unaltered**, followed by the result and the expected result.
Hints stay hidden until you ask for one with `tlings -hint`.
When a check passes, it shows TLC's output only with `-v` or if your file uses `Print` or `PrintT`.
Learning to read TLC's output is part of the tutorial.

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

## Layout

```
exercises/en/     original exercises (broken), English. The reference language
exercises/ko/     Korean translations. Only comments differ; code must match en
solutions/        solutions (English). Only look when you are stuck
go/               Go programs that go with Part 3. Run them as the exercises say, e.g. go run -race ./go/034_lost_update
work/             your workspace, created by tlings
cmd/tlings/       the runner. Exercise order and expectations are in cmd/tlings/exercises.go
```

## For authors

```sh
tlings -verify    # check every original, translation and solution
go test ./cmd/tlings
```

For each exercise, `-verify` checks that:

1. the original in every language fails **in the intended way**: exit code, an output phrase and the line it points to;
2. every translation has the same code as en (comments and blank lines are ignored);
3. the solution meets the expectation.

A missing translation is only a warning; learners get the English version instead.

To add an exercise:

1. Write the solution first (`solutions/`), then break it to make the original (`exercises/en/`).
2. Add it to `exercises.go`. Give `Broken.At` a code snippet, not a line number: line numbers differ between languages.
3. Translate it (`exercises/ko/`) and add the hint for each language.

Never use line numbers in explanations or hints, for the same reason.

Every `ASSUME` of the original must stay in the learner's file, or deleting it would "pass" the check.
tlings compares lines ignoring whitespace, with `???` matching anything; learners may add their own.
The `ASSUME` line containing `Broken.At` only has to keep that snippet, so an exercise can ask learners to correct a value there.

To add a language, add a `messages` value in `cmd/tlings/messages.go` and an `exercises/<lang>/` directory.

## License

[MIT](LICENSE)
