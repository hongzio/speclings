-- speclings lean 069: grind
--
-- 마지막 Part 7 은 프로그램이 올바르다는 것을 증명합니다. 먼저 더 강한
-- 도구부터.
--
-- grind 는 여러 종류의 추론을 합치고, 목표가 따라 나오거나 더 알아낼
-- 것이 없을 때까지 계속합니다:
--
--   - 등식: 무엇이 무엇과 같은지, 그래서 f a = f b
--   - 산술: omega 처럼 선형인 것, 그리고 (a + b) * (a + b) 처럼 변수끼리
--     곱하는 것도
--   - if, match 같은 것에 대한 경우 나누기
--   - grind [f] 는 정의 f 도 펼치고, grind [thm] 은 정리를 씁니다
--
-- grind 는 귀납법이나 일반화는 하지 않습니다. 그것은 여러분이 고르고,
-- 그다음 각 경우를 grind 가 처리합니다. 실패하면 알고 있던 사실들을
-- 나열하니, 무엇이 빠졌는지 읽어 보세요.
--
-- 아래의 가우스 공식은 012 의 sumTo 에 관한 것인데, (긴 rw 사슬이 아니면)
-- Part 5 의 도구로는 닿지 않습니다. 귀납 단계에 변수끼리의 곱이 있고,
-- omega 는 그것을 하지 않기 때문입니다. 이것과 나머지를 grind 로
-- 증명하세요.

def sumTo : Nat → Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo n

theorem gauss (n : Nat) : 2 * sumTo n = n * (n + 1) := by
  sorry

theorem square_sum (a b : Nat) : (a + b) * (a + b) = a * a + 2 * a * b + b * b := by
  sorry

theorem odd_succ (x : Nat) (h : x % 2 = 1) : (x + 1) % 2 = 0 := by
  sorry

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => len xs + 1

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  sorry
