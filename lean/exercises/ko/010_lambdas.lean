-- speclings lean 010: 익명 함수
--
-- fun x => e 는 이름 없는 함수입니다. (=> 대신 \mapsto 로 입력하는 ↦ 를
-- 써도 됩니다.)
--
--   fun x => x * 2             인자를 두 배로
--   fun (x : Nat) => x * 2     같은 함수, x 의 타입을 적은 것
--   (· * 2)                    같은 함수를 짧게. · (\. 로 입력) 이 인자
--
-- 함수는 값입니다. 다른 함수에 넘길 수 있고 (예: 리스트의 모든 원소에
-- 함수를 적용하는 List.map),
--
--   [1, 2, 3].map (fun x => x * 2)      [2, 4, 6]
--
-- 다른 값처럼 함수에서 돌려줄 수도 있습니다.
--
-- doubled 를 고치세요. 그다음 twice 를 채우세요. twice f x 는 x 에 f 를
-- 두 번 적용합니다. compose 도 채우세요. compose g f 는 f 를 적용한 다음
-- g 를 적용하는 함수입니다.

def doubled (xs : List Nat) : List Nat := xs.map (fun x -> x * 2)

#guard doubled [1, 2, 3] == [2, 4, 6]

def twice (f : Nat → Nat) (x : Nat) : Nat := sorry

#guard twice (· + 3) 10 == 16
#guard twice (fun x => x * x) 3 == 81

def compose (g f : Nat → Nat) : Nat → Nat := sorry

#guard compose (· + 1) (· * 2) 5 == 11
#guard compose (· * 2) (· + 1) 5 == 12
