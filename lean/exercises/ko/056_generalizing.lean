-- speclings lean 056: 일반화
--
-- sumAcc 는 반복문처럼 누산기로 리스트를 더합니다. 지금까지의 합을 acc
-- 에 들고 다닙니다. 0 에서 시작하는 sumTR 은 sum 과 같은 값을
-- 계산합니다. (꼬리 재귀라서 스택이 자라지 않습니다.)
--
-- sumAcc_eq 를 xs 에 대한 귀납법으로 증명해 보세요. cons 경우의 목표는
-- sumAcc xs (acc + x) 에 관한 것인데, 귀납 가정은 sumAcc xs acc 에 관한
-- 것입니다. acc + x 가 아니라, 처음 시작한 목표의 그 acc 입니다. 해 보고
-- omega 가 무엇을 보고하는지 읽어 보세요.
--
-- 해결책은 모든 acc 에 대해 명제를 증명해서, 귀납 가정도 모든 acc 에 대해
-- 성립하게 하는 것입니다:
--
--   induction xs generalizing acc with ...
--
-- revAcc 는 reverse 에 대해 같은 일을 합니다. 그 증명은 simp 를 통해
-- reverse 와 ++ 에 관한 라이브러리의 정리를 쓸 수 있습니다.

def sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs

def sumAcc : List Nat → Nat → Nat
  | [], acc => acc
  | x :: xs, acc => sumAcc xs (acc + x)

def sumTR (xs : List Nat) : Nat := sumAcc xs 0

theorem sumAcc_eq (xs : List Nat) (acc : Nat) : sumAcc xs acc = acc + sum xs := by
  sorry

theorem sumTR_eq (xs : List Nat) : sumTR xs = sum xs := by
  sorry

def revAcc : List Nat → List Nat → List Nat
  | [], acc => acc
  | x :: xs, acc => revAcc xs (x :: acc)

theorem revAcc_eq (xs acc : List Nat) : revAcc xs acc = xs.reverse ++ acc := by
  sorry
