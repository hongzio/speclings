-- speclings lean 058: 인덱스
--
-- Part 6 은 값에 의존하는 타입과 프로그램 안의 증명에 관한 것입니다. 첫
-- 예는 이미 보았습니다. xs[i] 는 배열의 위치 i 를 읽고, Lean 은
-- i < xs.size 임을 알아야 합니다. 증명이 없으면 거부합니다 (032 는 이를
-- 피하려고 xs[i]? 와 xs[i]! 를 썼습니다).
--
-- 증명은 가정에서 올 수 있습니다. 함수가 증명을 인자로 받을 수 있습니다:
--
--   def third (xs : Array Nat) (h : 2 < xs.size) : Nat := xs[2]
--
-- Lean 은 xs[2] 를 검사할 때 h 를 스스로 찾습니다. (xs[i]'h 는 증명을
-- 명시합니다.) 그러면 호출하는 쪽이 증명을 넘깁니다. 정해진 배열이라면
-- (by decide) 처럼요.
--
-- Fin n 은 n 보다 작은 Nat 들의 타입입니다. 수와, 그 수가 n 보다 작다는
-- 증명을 함께 담습니다. i : Fin xs.size 이면 xs[i] 에 다른 증명이
-- 필요 없습니다. ⟨1, h⟩ 는 수와 증명으로 Fin 을 만들고, i.val 은 그
-- 수입니다. Fin n 의 산술은 한 바퀴 돕니다. n 으로 나눈 나머지로
-- 계산합니다.
--
-- third 의 #guard 가 되도록 third 를 고치세요. 그다음 빈칸을 채우세요.

def third (xs : Array Nat) : Nat := xs[2]

#guard third #[10, 20, 30] (by decide) == 30

def lookup (a : Array String) (i : Fin a.size) : String := a[i]

def days : Array String := #["mon", "tue", "wed"]

#guard lookup days ⟨1, by decide⟩ == "tue"

#guard ((3 : Fin 5) + 4).val == sorry
#guard (7 : Fin 5).val == sorry
#guard (Fin.last 4).val == sorry
