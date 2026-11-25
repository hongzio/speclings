-- speclings lean 062: 벡터
--
-- 타입은 값을 인자로 받을 수 있습니다. Vec α n 은 α 타입 원소가 정확히
-- n 개인 리스트입니다:
--
--   inductive Vec (α : Type) : Nat → Type where
--     | nil : Vec α 0
--     | cons {n : Nat} : α → Vec α n → Vec α (n + 1)
--
-- 길이가 타입의 일부이므로 Lean 이 검사합니다. 아래 head 는
-- Vec α (n + 1) 을 받습니다. 비어 있을 수 없으므로 head 에는 nil 경우도,
-- Option 도 필요 없습니다. zip 은 길이 n 이 같은 두 벡터를 받습니다.
-- (라이브러리에도 Vector α n 이 있습니다. 크기 증명을 가진 Array 입니다.)
--
-- Lean 에게 두 타입은 계산해서 같으면 같습니다. Vec α (2 + 1) 은
-- Vec α 3 입니다. 하지만 변수 n 이 있으면, n + 0 은 n 으로 계산되는데
-- 0 + n 은 전혀 계산되지 않습니다. + 는 050 의 add 처럼 둘째 인자를
-- 풀어 가기 때문입니다. 그래서 거기서 add 0 n = n 에 귀납법이 필요했고,
-- 그래서 아래 append 가 컴파일되지 않습니다. nil 경우에 Lean 은 ys 가
-- Vec α (0 + n) 타입이어야 하는데, 그것이 Vec α n 이라는 것을 보지
-- 못합니다.
--
-- 두 경우 모두에서 길이가 계산되도록 append 의 타입을 고치세요. (힌트:
-- cons 경우에 길이는 xs 의 길이에 1 을 더한 것입니다.) 그다음 map 과
-- zip 을 채우세요.

inductive Vec (α : Type) : Nat → Type where
  | nil : Vec α 0
  | cons {n : Nat} : α → Vec α n → Vec α (n + 1)

namespace Vec

def head {α : Type} {n : Nat} : Vec α (n + 1) → α
  | cons x _ => x

def toList {α : Type} {n : Nat} : Vec α n → List α
  | nil => []
  | cons x xs => x :: xs.toList

def map {α β : Type} {n : Nat} (f : α → β) : Vec α n → Vec β n := sorry

def zip {α β : Type} {n : Nat} : Vec α n → Vec β n → Vec (α × β) n := sorry

def append {α : Type} {m n : Nat} : Vec α m → Vec α n → Vec α (m + n)
  | nil, ys => ys
  | cons x xs, ys => cons x (append xs ys)

end Vec

def v3 : Vec Nat 3 := .cons 1 (.cons 2 (.cons 3 .nil))

#guard v3.head == 1
#guard (v3.map (· * 10)).toList == [10, 20, 30]
#guard (Vec.zip v3 v3).toList == [(1, 1), (2, 2), (3, 3)]
#guard (v3.append v3).toList == [1, 2, 3, 1, 2, 3]
