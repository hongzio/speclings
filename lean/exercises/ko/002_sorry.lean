-- leanlings 002: sorry
--
-- sorry 는 아직 쓰지 않은 무언가를 나타냅니다. Lean 은 어떤 값이나 증명
-- 자리에도 sorry 를 받아 주지만, 경고를 냅니다:
--
--   warning: declaration uses `sorry`
--
-- 이제부터 문제에는 여러분이 바꿀 sorry 가 있고, sorry 가 하나도 남지
-- 않으면 통과합니다. 나머지는 주어진 것이니 sorry 만 바꾸세요. #eval 이나
-- 보조 정의처럼 여러분이 쓸 것을 더하는 건 괜찮습니다.
--
-- 아래 triple 은 #guard 가 검사하듯 인자에 3 을 곱해야 합니다. triple 이
-- sorry 인 동안에는 #guard 를 실행할 수 없어서, 채우기 전까지는 Lean 이
-- 이것들도 에러로 보고합니다.
--
-- Lean 은 증명 보조기이기도 합니다. theorem 은 사실을 말하고 증명합니다:
--
--   theorem 이름 : 명제 := 증명
--
-- double_two 는 double 2 가 4 라고 말합니다. 이건 계산으로 성립합니다:
-- double 2 는 2 + 2 이고, 이는 4 입니다. 증명 rfl ("반사성") 은 양쪽을
-- 계산한 값이 같은 등식을 증명합니다. double_two 의 sorry 를 rfl 로
-- 바꾸세요.

def double (n : Nat) : Nat := n + n

def triple (n : Nat) : Nat := sorry

#guard triple 0 == 0
#guard triple 4 == 12

theorem double_two : double 2 = 4 := sorry
