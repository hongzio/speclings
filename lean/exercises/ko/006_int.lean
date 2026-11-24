-- leanlings 006: 정수
--
-- Int 는 정수 ..., -2, -1, 0, 1, 2, ... 의 타입입니다. 음수 리터럴에는
-- (-5 : Int) 처럼 타입이 필요합니다. Lean 이 이미 그 자리에 Int 를
-- 기대하고 있다면 필요 없습니다.
--
-- Int 나눗셈도 음의 무한대 쪽으로 내림하고, 나머지는 음수가 되지
-- 않습니다. (-7 : Int) / 2 는 -4 입니다. (Go 의 -7 / 2 는 -3 입니다.)
--
-- Nat n 을 Int 로 바꾸려면 (n : Int) 로 씁니다. Lean 이 Int 를 기대하는
-- 자리에서는 알아서 바꿔 줍니다:
--
--   def toInt (n : Nat) : Int := n
--
-- 반대 방향은 정보를 잃습니다. Int.toNat 은 음수를 0 으로 만들고,
-- Int.natAbs 는 부호를 버립니다.
--
-- let 은 정의 안에서 값에 이름을 붙입니다:
--
--   let diff := paid - price
--
-- 모든 값의 타입은 하나이고, 그 값을 계산하는 곳에서 정해집니다. 아래
-- change 에서 paid 와 price 는 Nat 이므로 diff 도 Nat 이고, Nat 뺄셈으로
-- 계산됩니다. 나중에 diff 를 Int 로 바꿔도 음수 결과는 돌아오지 않습니다.
--
-- 빈칸을 채우세요. 그다음 change 를 고치세요. 낸 돈보다 가격이 높으면
-- 음수여야 합니다.

#guard (-7 : Int) / 2 == sorry
#guard (-7 : Int) % 2 == sorry
#guard Int.toNat (-3) == sorry
#guard Int.natAbs (-3) == sorry

def change (paid price : Nat) : Int :=
  let diff := paid - price
  diff

#guard change 5 3 == 2
#guard change 3 5 == -2
