-- speclings lean 023: expressions (solution)

inductive Expr where
  | num (n : Nat)
  | add (a b : Expr)
  | mul (a b : Expr)
  deriving Repr, BEq

-- (2 + 3) * 4
def sample : Expr := .mul (.add (.num 2) (.num 3)) (.num 4)

def eval : Expr → Nat
  | .num n => n
  | .add a b => eval a + eval b
  | .mul a b => eval a * eval b

#guard eval sample == 20
#guard eval (.num 7) == 7

def render : Expr → String
  | .num n => toString n
  | .add a b => s!"({render a} + {render b})"
  | .mul a b => s!"({render a} * {render b})"

#guard render sample == "((2 + 3) * 4)"
#guard render (.num 7) == "7"

def simplify : Expr → Expr
  | .num n => .num n
  | .add a b =>
    match simplify a, simplify b with
    | .num 0, b' => b'
    | a', .num 0 => a'
    | a', b' => .add a' b'
  | .mul a b =>
    match simplify a, simplify b with
    | .num 1, b' => b'
    | a', .num 1 => a'
    | a', b' => .mul a' b'

#guard simplify (.add (.num 0) (.num 5)) == .num 5
#guard simplify (.mul (.add (.num 3) (.num 0)) (.num 1)) == .num 3
#guard simplify sample == sample
