-- speclings lean 016: 순서쌍
--
-- 순서쌍은 같거나 다른 타입의 값 두 개를 담습니다. 순서쌍의 타입은
-- × (\x 로 입력) 로 씁니다:
--
--   (3, "three") : Nat × String
--
-- p.1 과 p.2 (또는 p.fst 와 p.snd) 가 두 부분이고, let 이나 fun 으로
-- 순서쌍을 풀 수 있습니다:
--
--   let (q, r) := (7 / 2, 7 % 2)
--   fun (a, b) => a + b
--
-- zip 은 두 리스트를 짝짓습니다: [1, 2].zip ["a", "b"] 는
-- [(1, "a"), (2, "b")].
--
-- divMod (몫과 나머지), swap, sumPairs (각 순서쌍의 합), indexed (각
-- 원소와 그 위치) 를 채우세요.

def divMod (a b : Nat) : Nat × Nat := sorry

#guard divMod 7 2 == (3, 1)

def swap (p : Nat × String) : String × Nat := sorry

#guard swap (1, "one") == ("one", 1)

def sumPairs (xs : List (Nat × Nat)) : List Nat := sorry

#guard sumPairs [(1, 2), (3, 4)] == [3, 7]

def indexed (xs : List String) : List (Nat × String) := sorry

#guard indexed ["a", "b", "c"] == [(0, "a"), (1, "b"), (2, "c")]
