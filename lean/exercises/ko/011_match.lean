-- leanlings 011: 패턴 매칭
--
-- match 는 값의 모양을 보고 맞는 첫 번째 경우를 고릅니다:
--
--   def describe (n : Nat) : String :=
--     match n with
--     | 0 => "zero"
--     | 1 => "one"
--     | _ => "many"         -- _ 는 무엇에나 맞음
--
-- 인자에 이름을 붙이지 않고 정의에서 바로 매칭할 수도 있습니다:
--
--   def isZero : Nat → Bool
--     | 0 => true
--     | _ => false
--
-- 패턴은 값의 일부에 이름을 붙일 수 있습니다. n + 1 은 0 이 아닌 모든
-- Nat 에 맞고, 하나 작은 수를 n 이라고 부릅니다:
--
--   def pred : Nat → Nat
--     | 0 => 0
--     | n + 1 => n
--
-- Lean 은 경우들이 모든 값을 덮는지 검사합니다. 빠진 경우가 있으면
-- 패턴으로 알려 줍니다. 거기서 Nat.succ n 은 n + 1 이라는 뜻이니,
-- Nat.succ (Nat.succ _) 는 _ + 2 꼴의 수, 곧 2 이상입니다.
--
-- size 를 고치세요. 2 부터는 모두 "many" 입니다. 그다음 minusTwo 를
-- 채우세요. Nat 뺄셈처럼 2 를 빼고, n + 2 패턴을 씁니다.

def size : Nat → String
  | 0 => "none"
  | 1 => "one"

#guard size 0 == "none"
#guard size 1 == "one"
#guard size 5 == "many"

def minusTwo : Nat → Nat := sorry

#guard minusTwo 0 == 0
#guard minusTwo 1 == 0
#guard minusTwo 7 == 5
