# speclings

**English** | [한국어](README.ko.md)

Learn formal verification by fixing small, broken files, one at a time.
Each track teaches one tool, in the style of [ziglings](https://codeberg.org/ziglings/exercises/) and [rustlings](https://github.com/rust-lang/rustlings).

## Tracks

| Track | What you learn | Exercises |
|---|---|---|
| [`tla`](tla/README.md) | TLA+ and the TLC model checker: describe a system as a state machine and check every behavior of a small model of it | 53 |
| [`lean`](lean/README.md) | Lean 4: functional programs, and proofs about them that the computer checks | 73 |

More tracks are planned: property-based testing, Quint, and model-based testing with ITF traces.
The tracks are independent of each other, so start with the one you need.

## Getting started

You need [mise](https://mise.jdx.dev/) on macOS or Linux. It installs everything else.

```sh
git clone https://github.com/hongzio/speclings.git && cd speclings
mise trust           # allow this directory's mise.toml
mise install         # Go, and the tools of every track (Lean: about 640 MB to download, 3 GB on disk)
speclings            # the tracks and your progress
speclings tla        # start (or continue) a track
speclings -lang ko   # or pick a language first; it is remembered
```

To install the tools of one track only:

```sh
mise install go java http:tla2tools http:tla-community-modules   # tla
mise install go github:leanprover/lean4                          # lean
```

`speclings` is `bin/speclings`. mise puts `bin/` on your PATH when it is
[activated in your shell](https://mise.jdx.dev/getting-started.html#activate-mise);
otherwise run `mise exec -- speclings`.
It rebuilds the runner on every run (cached), so new exercises never require a reinstall.

You solve exercises in `work/<track>/`. When you reach an exercise, speclings copies it there in your language.
The originals in `<track>/exercises/` stay untouched.

## Commands

| Command | What it does |
|---|---|
| `speclings` | Show the tracks and your progress |
| `speclings <track>` | Check the track's exercises in order from where you left off; stop at the first failure |
| `speclings <track> -watch` | Same, and check again whenever you save a file in `work/<track>/` |
| `speclings <track> -n 3` | Check exercise 3 only (progress is not updated) |
| `speclings <track> -s 3` | Check in order starting from exercise 3 |
| `speclings <track> -restore 3` | Restore exercise 3 to its original state (your files are kept as `.bak`) |
| `speclings <track> -hint` | Show a hint for the current exercise (`-hint -n 3`: for exercise 3) |
| `speclings <track> -v` | Also show the tool's output, warnings included, when a check passes |
| `speclings <track> -reset` | Clear the track's progress |
| `speclings -lang ko` | Switch language, for every track. Exercises already in `work/` keep their language |

On failure, speclings shows the tool's output **unaltered**, followed by the result and the expected result.
Learning to read it is part of every track.
Hints stay hidden until you ask for one with `-hint`.
Each track's README says what it checks and what it shows when a check passes.

## Layout

```
cmd/speclings/     the runner. The tracks are listed in main.go, in order
internal/lings/    what every track shares: commands, workspace, progress, verify
<track>/           a track: exercises/<lang>/, solutions/, its README, and track/,
                   the Go package that lists the exercises and knows how to check them
work/<track>/      your workspace, created by speclings
bin/               speclings, and tlc (TLC with the TLA+ CommunityModules)
```

## For authors

```sh
speclings verify          # check every original, translation and solution (mise run verify)
speclings verify lean     # of one track
go test ./...             # (mise run test)
```

For each exercise, `verify` checks that:

1. the original in every language fails **in the intended way**, as the track defines it;
2. every translation has the same code as en (comments and blank lines are ignored);
3. the solution passes.

A missing translation is only a warning; learners get the English version instead.

Rules for every track (each track's README adds its own):

- Write the solution first (`<track>/solutions/`), then break it to make the original (`<track>/exercises/en/`).
- Add the exercise to `<track>/track/exercises.go`. Give `Broken.At` a code snippet, not a line number: line numbers differ between languages.
- Never use line numbers in explanations or hints, for the same reason.
- Translate it (`<track>/exercises/ko/`) and add the hint for each language.

To add a language, add a catalog to `internal/lings/messages.go` and to every track's `track/messages.go`, and `exercises/<lang>/` directories.

To add a track, create `<name>/` with `exercises/en/`, `solutions/` and a Go package that implements `lings.Track`
(see `internal/lings/track.go`), add it to `cmd/speclings/main.go`, and its tools to `mise.toml`.

## License

[MIT](LICENSE)
