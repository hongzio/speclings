-- speclings lean 074: a compiler
--
-- This compiles the expressions of 023 to a stack machine. A program is a
-- list of instructions; exec runs it on a stack, a list whose head is the
-- top:
--
--   push n    put n on the stack
--   add       take the top two numbers off, put their sum
--   mul       the same, with the product
--
-- compile puts the code for both operands first, then the operation, so
-- (2 + 3) * 4 becomes push 2, push 3, add, push 4, mul. The #eval below
-- runs it.
--
-- compile_correct says that running the code of e leaves exactly its
-- value. Proving it by induction on e gets stuck: the code for a + b runs
-- the code for a with more code after it, and on a stack that is not
-- empty, while the induction hypothesis only knows about code run alone
-- on []. So prove the general statement first, for any code after and any
-- stack: exec_compile, by induction on e generalizing is and s (056).
-- simp, with the definitions and the induction hypotheses, does each case.

inductive Expr where
  | num (n : Nat)
  | add (a b : Expr)
  | mul (a b : Expr)

def eval : Expr → Nat
  | .num n => n
  | .add a b => eval a + eval b
  | .mul a b => eval a * eval b

inductive Instr where
  | push (n : Nat)
  | add
  | mul

def exec : List Instr → List Nat → List Nat
  | [], s => s
  | .push n :: is, s => exec is (n :: s)
  | .add :: is, b :: a :: s => exec is ((a + b) :: s)
  | .mul :: is, b :: a :: s => exec is ((a * b) :: s)
  | _ :: is, s => exec is s

def compile : Expr → List Instr
  | .num n => [.push n]
  | .add a b => compile a ++ compile b ++ [.add]
  | .mul a b => compile a ++ compile b ++ [.mul]

#eval exec (compile (.mul (.add (.num 2) (.num 3)) (.num 4))) []

theorem exec_compile (e : Expr) (is : List Instr) (s : List Nat) :
    exec (compile e ++ is) s = exec is (eval e :: s) := by
  sorry

theorem compile_correct (e : Expr) : exec (compile e) [] = [eval e] := by
  sorry
