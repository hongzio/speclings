-- speclings lean 074: a compiler (solution)

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
  induction e generalizing is s with
  | num n => simp [compile, exec, eval]
  | add a b iha ihb => simp [compile, eval, iha, ihb, exec]
  | mul a b iha ihb => simp [compile, eval, iha, ihb, exec]

theorem compile_correct (e : Expr) : exec (compile e) [] = [eval e] := by
  simpa [exec] using exec_compile e [] []
