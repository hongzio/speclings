-- leanlings 057: quiz 5
--
-- In 023 you wrote simplify, which removes additions of 0 and
-- multiplications by 1 from an expression. Here is a version that does the
-- same through two helpers: addS a b builds a + b, but leaves out a 0, and
-- mulS a b builds a * b, but leaves out a 1. Prove that simplify does not
-- change the value of an expression.
--
-- Prove a theorem about each helper first, then simplify_correct by
-- induction on e.
--
-- For the helpers, unfold addS shows the match of its definition. split
-- then gives one goal per case of a match in the goal, with what the case
-- matched as a hypothesis. simp [eval] finishes each.
--
-- (Splitting the work like this is a design choice: written with nested
-- matches, as in 023, simplify is much harder to prove things about.)

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
  sorry

theorem eval_mulS (a b : Expr) : eval (mulS a b) = eval a * eval b := by
  sorry

theorem simplify_correct (e : Expr) : eval (simplify e) = eval e := by
  sorry
