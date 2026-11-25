-- speclings lean 060: quiz 5 (solution)

inductive Expr where
  | num (n : Nat)
  | add (a b : Expr)
  | mul (a b : Expr)

def eval : Expr → Nat
  | .num n => n
  | .add a b => eval a + eval b
  | .mul a b => eval a * eval b

def addS : Expr → Expr → Expr
  | .num 0, b => b
  | a, .num 0 => a
  | a, b => .add a b

def mulS : Expr → Expr → Expr
  | .num 1, b => b
  | a, .num 1 => a
  | a, b => .mul a b

def simplify : Expr → Expr
  | .num n => .num n
  | .add a b => addS (simplify a) (simplify b)
  | .mul a b => mulS (simplify a) (simplify b)

theorem eval_addS (a b : Expr) : eval (addS a b) = eval a + eval b := by
  unfold addS
  split <;> simp [eval]

theorem eval_mulS (a b : Expr) : eval (mulS a b) = eval a * eval b := by
  unfold mulS
  split <;> simp [eval]

theorem simplify_correct (e : Expr) : eval (simplify e) = eval e := by
  induction e with
  | num n => rfl
  | add a b iha ihb => rw [simplify, eval_addS, iha, ihb, eval]
  | mul a b iha ihb => rw [simplify, eval_mulS, iha, ihb, eval]
