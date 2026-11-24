-- speclings lean 023: expressions
--
-- Programs are data too. An arithmetic expression is a number, a sum of
-- two expressions or a product of two expressions:
--
--   inductive Expr where
--     | num (n : Nat)
--     | add (a b : Expr)
--     | mul (a b : Expr)
--
-- sample below is (2 + 3) * 4, written as the tree of its operations.
-- Part 7 comes back to Expr, to prove a small compiler for it correct.
--
-- Fill in:
--
--   eval       the value of an expression
--   render     the expression as text, with parentheses around every
--              + and *, like "((2 + 3) * 4)"
--   simplify   the same expression without additions of 0 and without
--              multiplications by 1, anywhere in it
--
-- For simplify, simplify the two parts first. Then match on both results
-- at once: match simplify a, simplify b with | .num 0, b' => b' | ...

inductive Expr where
  | num (n : Nat)
  | add (a b : Expr)
  | mul (a b : Expr)
  deriving Repr, BEq

-- (2 + 3) * 4
def sample : Expr := .mul (.add (.num 2) (.num 3)) (.num 4)

def eval : Expr → Nat := sorry

#guard eval sample == 20
#guard eval (.num 7) == 7

def render : Expr → String := sorry

#guard render sample == "((2 + 3) * 4)"
#guard render (.num 7) == "7"

def simplify : Expr → Expr := sorry

#guard simplify (.add (.num 0) (.num 5)) == .num 5
#guard simplify (.mul (.add (.num 3) (.num 0)) (.num 1)) == .num 3
#guard simplify sample == sample
