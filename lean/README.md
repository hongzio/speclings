# speclings: the Lean track

**English** | [한국어](README.ko.md) · [speclings](../README.md)

Learn Lean 4, the programming language and proof assistant, by fixing small, broken Lean files one at a time.

There are 73 exercises, in eight parts: Part 0: tools, Part 1: values and functions, Part 2: data, Part 3: programs, Part 4: propositions and proofs, Part 5: induction, Part 6: dependent types, Part 7: verified programs.

Run it with `speclings lean`. Setup and commands are in the [main README](../README.md).
Before checking, speclings builds the checker in `checker/` (cached; the very first build takes a few seconds).

When a check passes, speclings shows the output of your `#eval`s and `#check`s; warnings (such as linters) only with `-v`.

## Editor

speclings checks your files from the terminal, but Lean is best written in an editor that runs Lean as you type
and shows the goals of a proof at the cursor (the infoview). Use both side by side.

- **Neovim**: [lean.nvim](https://github.com/Julian/lean.nvim). It runs the `lean` on your PATH, so start Neovim
  from a shell where mise is active (or put mise's shims on your PATH). `:checkhealth lean` should find Lake.
- **VS Code**: the [Lean 4 extension](https://marketplace.visualstudio.com/items?itemName=leanprover.lean4).
  It works best with [elan](https://github.com/leanprover/elan), which reads `lean-toolchain` at the repository root
  and uses the same Lean version as mise. Open the repository root, not `work/lean/`.

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
speclings compares the compiled declarations, not the text (see `checker/`), so you may format your file as you like and add helper lemmas.
Each check takes about a second.

## For authors

`speclings verify lean` checks that the Lean on PATH, `lean-toolchain` and `mise.toml` agree on the version, and for each exercise that
the original in every language fails in the intended way (a message of Lean, its kind or a phrase, and the line it points to),
that it fails the check, and that an empty file does not pass.

On top of the [rules for every track](../README.md#for-authors):

- Use `fill()` when the original compiles apart from its `sorry`s and `#` commands: then it is the reference the learner's file is compared with.
  Use `fix()` for an original with a mistake on purpose (a syntax or type error). Such an exercise needs a `#guard` that uses its definitions, or an empty file would pass.
- Lean reports a `sorry` at the name of its declaration, so `Broken.At` is the declaration: `blank("def triple")`.
- Write each `#` command (`#guard`, `#eval`, `#check`, ...) on one line. They are removed from the reference, line by line.
- Do not use `#guard_msgs`: its expected output is a comment, which translations would change.
- Import nothing, or only modules that ship with Lean. Every import makes every check slower (`import Std` adds about 0.4 s).

To upgrade Lean, change the version in `mise.toml` and `lean-toolchain` (both at the repository root), run `mise install`, then `speclings verify lean`: Lean's messages change between versions.

## Beyond this track

- [Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/): Lean as a programming language.
- [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/): dependent type theory and proofs.
- [The Lean Language Reference](https://lean-lang.org/doc/reference/latest/).
- [Natural Number Game](https://adam.math.hhu.de/#/g/leanprover-community/nng4): proofs as a game, in the browser.
- [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/): mathematics with Mathlib.
- [The Hitchhiker's Guide to Logical Verification](https://lean-forward.github.io/hitchhikers-guide/2024/): semantics and program verification.
