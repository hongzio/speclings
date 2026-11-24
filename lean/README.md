# leanlings

**English** | [한국어](README.ko.md)

Learn Lean 4, the programming language and proof assistant, by fixing small, broken Lean files one at a time.
Modeled after [ziglings](https://codeberg.org/ziglings/exercises/) and [rustlings](https://github.com/rust-lang/rustlings).

> **Work in progress:** there are 65 exercises so far (Part 0: tools, Part 1: values and functions, Part 2: data, Part 3: programs, Part 4: propositions and proofs, Part 5: induction, Part 6: dependent types), and more parts are being added.

## Getting started

You need [mise](https://mise.jdx.dev/) on macOS or Linux. It installs everything else.

```sh
git clone https://github.com/hongzio/leanlings.git && cd leanlings
mise trust         # allow this directory's mise.toml
mise install       # Go and Lean (about 640 MB to download, 3 GB on disk)
leanlings          # start from the first exercise (English)
leanlings -lang ko # or pick a language first; it is remembered
```

`leanlings` is `bin/leanlings`. mise puts `bin/` on your PATH when it is
[activated in your shell](https://mise.jdx.dev/getting-started.html#activate-mise);
otherwise run `mise exec -- leanlings`.
It rebuilds the runner and the checker on every run (cached; the very first build takes a few seconds), so new exercises never require a reinstall.

You solve exercises in `work/`. When you reach an exercise, leanlings copies it there in your language.
The originals in `exercises/` stay untouched.

## Editor

leanlings checks your files from the terminal, but Lean is best written in an editor that runs Lean as you type
and shows the goals of a proof at the cursor (the infoview). Use both side by side.

- **Neovim**: [lean.nvim](https://github.com/Julian/lean.nvim). It runs the `lean` on your PATH, so start Neovim
  from a shell where mise is active (or put mise's shims on your PATH). `:checkhealth lean` should find Lake.
- **VS Code**: the [Lean 4 extension](https://marketplace.visualstudio.com/items?itemName=leanprover.lean4).
  It works best with [elan](https://github.com/leanprover/elan), which reads `lean-toolchain` and uses the same Lean version as mise.

## Commands

| Command | What it does |
|---|---|
| `leanlings` | Check exercises in order from where you left off; stop at the first failure |
| `leanlings -watch` | Same, and check again whenever you save a file in `work/` |
| `leanlings -lang ko` | Switch language. Exercises already in `work/` keep their language |
| `leanlings -n 3` | Check exercise 3 only (progress is not updated) |
| `leanlings -s 3` | Check in order starting from exercise 3 |
| `leanlings -restore 3` | Restore exercise 3 to its original state (your file is kept as `.bak`) |
| `leanlings -hint` | Show a hint for the current exercise (`-hint -n 3`: for exercise 3) |
| `leanlings -v` | When a check passes, also show Lean's warnings |
| `leanlings -reset` | Clear progress |

On failure, leanlings shows Lean's messages **unaltered**, followed by the result and the expected result.
Hints stay hidden until you ask for one with `leanlings -hint`.
When a check passes, it shows the output of your `#eval`s and `#check`s; warnings (such as linters) only with `-v`.
Learning to read Lean's messages is part of the tutorial.

## How an exercise passes

Every exercise passes when:

1. Lean reports no errors and no `sorry`.
2. Every `#guard` of the original is still in your file. Whitespace may differ, and you may add your own.

Exercises with `sorry`s to fill in (expected: "with the given definitions and statements unchanged") also require:

3. Every definition and theorem of the original is still there, with the same statement.
   Definitions without `sorry` were given to you and must stay as they are.
4. Proofs depend only on Lean's standard axioms (`propext`, `Classical.choice`, `Quot.sound`) and on axioms the exercise itself declares.
   An `axiom` of your own, `native_decide` or a leftover `sorry` is not a proof.

Some exercises also ask for what the program prints, or forbid a tactic (for example `omega` in an exercise on induction).

Why check this much: changing a statement to `True`, or a given definition so that `rfl` proves the theorem, makes Lean happy without solving anything.
leanlings compares the compiled declarations, not the text (see `checker/`), so you may format your file as you like and add helper lemmas.
Each check takes about a second.

## Layout

```
exercises/en/     original exercises (broken), English. The reference language
exercises/ko/     Korean translations. Only comments differ; code must match en
solutions/        solutions (English). Only look when you are stuck
work/             your workspace, created by leanlings
cmd/leanlings/    the runner. Exercise order and expectations are in cmd/leanlings/exercises.go
checker/          the Lean program that compares your file with the original
```

## For authors

```sh
leanlings -verify   # check every original, translation and solution
go test ./cmd/leanlings
```

`-verify` checks that the Lean on PATH, `lean-toolchain` and `mise.toml` agree on the version, and for each exercise that:

1. the original in every language fails **in the intended way**: a message of Lean, its kind or a phrase, and the line it points to;
2. every translation has the same code as en (comments and blank lines are ignored);
3. the solution passes, and an empty file does not.

A missing translation is only a warning; learners get the English version instead.

To add an exercise:

1. Write the solution first (`solutions/`), then break it to make the original (`exercises/en/`).
2. Add it to `exercises.go`. Use `fill()` when the original compiles apart from its `sorry`s and `#` commands: then it is the reference the learner's file is compared with.
   Use `fix()` for an original with a mistake on purpose (a syntax or type error). Such an exercise needs a `#guard` that uses its definitions, or an empty file would pass.
3. Give `Broken.At` a code snippet, not a line number: line numbers differ between languages. Lean reports a `sorry` at the name of its declaration, so `blank("def triple")`.
4. Translate it (`exercises/ko/`) and add the hint for each language.

Rules for exercise files:

- Never use line numbers in explanations or hints, for the same reason.
- Write each `#` command (`#guard`, `#eval`, `#check`, ...) on one line. They are removed from the reference, line by line.
- Do not use `#guard_msgs`: its expected output is a comment, which translations would change.
- Import nothing, or only modules that ship with Lean. Every import makes every check slower (`import Std` adds about 0.4 s).

To upgrade Lean, change the version in `mise.toml` and `lean-toolchain`, run `mise install`, then `leanlings -verify`: Lean's messages change between versions.

## Beyond leanlings

- [Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/): Lean as a programming language.
- [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/): dependent type theory and proofs.
- [The Lean Language Reference](https://lean-lang.org/doc/reference/latest/).
- [Natural Number Game](https://adam.math.hhu.de/#/g/leanprover-community/nng4): proofs as a game, in the browser.
- [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/): mathematics with Mathlib.
- [The Hitchhiker's Guide to Logical Verification](https://lean-forward.github.io/hitchhikers-guide/2024/): semantics and program verification.

## License

[MIT](LICENSE)
