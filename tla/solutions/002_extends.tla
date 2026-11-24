----------------------------- MODULE 002_extends -----------------------------
EXTENDS Naturals
\* speclings tla 002: EXTENDS
\*
\* You can write numbers like 1, 2, 3 directly, but operators such as
\* + - * < are not part of the TLA+ language itself. They are defined in
\* standard modules, and you import a module with EXTENDS to use them.
\* EXTENDS goes on the line right after the module header.
\*
\*   EXTENDS Naturals
\*   EXTENDS Naturals, Sequences      separate several with commas
\*
\* Frequently used standard modules:
\*
\*   Naturals     Nat  + - * \div %  ..  < <= > >=
\*   Integers     everything in Naturals, plus Int and negative numbers
\*   Sequences    Seq  Len  Append  Head  Tail  \o
\*   FiniteSets   Cardinality  IsFiniteSet
\*   TLC          TLC-specific tools such as Print, PrintT, Assert
\*
\* The line below means "define Two to be 1 + 1". == is a definition,
\* covered in detail in 007. For now, just look at where + comes from.

Two == 1 + 1

=============================================================================
