-- speclings lean 009: 함수
--
-- 인자는 함수 뒤에 공백으로 구분해 쓰고, 괄호나 쉼표는 쓰지 않습니다:
-- area 3 4. (area (3, 4) 는 순서쌍 하나를 인자로 넘깁니다.)
--
-- Nat 두 개를 받아 Nat 을 돌려주는 함수의 타입은 Nat → Nat → Nat 입니다
-- (→ 는 \to 로 입력하거나 -> 로 씁니다). 화살표는 오른쪽부터 묶입니다:
--
--   Nat → Nat → Nat    은    Nat → (Nat → Nat)
--
-- 그러니 인자가 둘인 함수는 첫 인자를 받아 둘째 인자의 함수를 돌려주는
-- 함수입니다. 첫 인자만 줘도 되고, 그러면 그 함수가 나옵니다:
--
--   #check area 3        area 3 : Nat → Nat
--   #eval area 3 4       12, 즉 (area 3) 4
--
-- 이것을 부분 적용이라고 합니다. Nat 이 와야 할 자리에 Nat → Nat 같은
-- 타입의 값이 있다는 에러가 나면, 인자가 하나 빠진 것입니다.
--
-- square 를 고치세요. 그다음 area 에 인자 하나만 줘서 areaWithWidth2 를
-- 채우세요.

def area (width height : Nat) : Nat := width * height

#check area

def square (side : Nat) : Nat := area side

#guard square 3 == 9

def areaWithWidth2 : Nat → Nat := sorry

#guard areaWithWidth2 5 == 10
