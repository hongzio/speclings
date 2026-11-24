------------------------- MODULE 015_function_sets --------------------------
EXTENDS Integers, FiniteSets
\* speclings tla 015: sets of functions
\*
\*   [S -> T]    the set of ALL functions with domain S and values in T
\*
\* [{"a", "b"} -> {0, 1}] has 4 elements, one for each way to give "a"
\* and "b" a value 0 or 1. In general [S -> T] has |T|^|S| elements.
\*
\* [S -> T] is just a set. Specs use it with \in, often as a type check:
\*
\*   balance \in [Accounts -> Int]    "balance is a function from
\*                                     accounts to integers"
\*
\* Fill in the blanks.

Flags == [{"a", "b"} -> BOOLEAN]

ASSUME [x \in {"a", "b"} |-> TRUE] \in Flags
ASSUME Cardinality(Flags) = ???
ASSUME ([x \in {"a"} |-> TRUE] \in Flags) = ???
ASSUME Cardinality([1..3 -> 1..2]) = ???

=============================================================================
