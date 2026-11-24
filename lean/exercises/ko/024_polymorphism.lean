-- speclings lean 024: 다형성
--
-- 어떤 함수는 모든 타입에 대해 똑같이 동작합니다. 순서쌍을 맞바꾸는 데는
-- 안에 무엇이 있는지 상관없습니다. 타입도 인자가 될 수 있고, 중괄호로
-- 씁니다:
--
--   def swap {α β : Type} (p : α × β) : β × α := ...
--
-- (α 는 \a, β 는 \b 로 입력.) 중괄호는 α 와 β 를 암시적(implicit) 인자로
-- 만듭니다. 호출하는 쪽은 넘기지 않고, Lean 이 p 로부터 알아냅니다.
-- swap (1, "a") 는 α := Nat, β := String 을 씁니다. #check @swap 은 암시적
-- 인자까지 보여 줍니다.
--
-- Lean 은 α 처럼 선언하지 않은 이름에 대해 암시적 인자를 알아서
-- 붙이기도 합니다 ("auto-bound"). 그래서 def swap (p : α × β) 도 됩니다.
-- 이 문제들은 눈에 보이도록 굳이 선언합니다.
--
-- 타입도 타입을 인자로 받을 수 있습니다: List Nat, Option String. 아래
-- Tree α 는 값의 타입이 α 인 트리입니다.
--
-- swap, mapOption (안에 값이 있으면 f 를 적용), mapTree (트리의 모든 값에
-- f 를 적용) 를 채우세요.

def swap {α β : Type} (p : α × β) : β × α := sorry

#check @swap

#guard swap (1, "a") == ("a", 1)
#guard swap ("a", true) == (true, "a")

def mapOption {α β : Type} (f : α → β) : Option α → Option β := sorry

#guard mapOption (· + 1) (some 2) == some 3
#guard mapOption (· + 1) none == none
#guard mapOption toString (some 7) == some "7"

inductive Tree (α : Type) where
  | leaf
  | node (left : Tree α) (value : α) (right : Tree α)
  deriving Repr, BEq

def mapTree {α β : Type} (f : α → β) : Tree α → Tree β := sorry

#guard mapTree toString (.node .leaf 1 (.node .leaf 2 .leaf)) == .node .leaf "1" (.node .leaf "2" .leaf)
