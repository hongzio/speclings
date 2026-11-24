-- speclings lean 060: 부분 타입
--
-- { n : Nat // n % 2 = 0 } 은 n % 2 = 0 인 Nat n 들의 타입입니다. 각 값은
-- 수와 그 수에 관한 증명의 쌍입니다.
--
--   ⟨4, rfl⟩ : { n : Nat // n % 2 = 0 }     4 % 2 = 0 은 계산으로 성립
--   e.val                                     수
--   e.property                                증명, e.val % 2 = 0
--
-- 이런 값을 돌려주는 함수는, 보통 인자들의 성질로부터, 결과가 그 성질을
-- 가진다는 것을 증명해야 합니다. have 는 증명의 나머지에서 쓸 사실에
-- 이름을 붙여서 omega 가 쓸 수 있게 합니다:
--
--   by have := a.property; omega
--
-- 실행할 때는 수만 남습니다. 증명은 프로그램이 돌 때 비용이 없습니다.
--
-- ten, addEven, double (2 * n), three 를 채우세요.

def EvenNat := { n : Nat // n % 2 = 0 }

def four : EvenNat := ⟨4, rfl⟩

def ten : EvenNat := sorry

def addEven (a b : EvenNat) : EvenNat := sorry

def double (n : Nat) : EvenNat := sorry

def half (e : EvenNat) : Nat := e.val / 2

#guard ten.val == 10
#guard (addEven four ten).val == 14
#guard (double 7).val == 14
#guard half (double 7) == 7

def PosNat := { n : Nat // n > 0 }

def divPos (a : Nat) (b : PosNat) : Nat := a / b.val

def three : PosNat := sorry

#guard divPos 10 three == 3
