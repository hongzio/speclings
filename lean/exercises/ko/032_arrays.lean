-- speclings lean 032: 배열
--
-- Array 는 List 와 비슷하지만 메모리 한 덩어리에 저장되므로, 어느 위치든
-- 빠르게 읽을 수 있습니다. 배열은 #[1, 2, 3] 처럼 씁니다.
--
--   a.size          원소 개수
--   a.push x        끝에 x 를 더한 a
--   a[i]?           위치 i 의 원소를 some 으로, 없으면 none
--   a[i]!           위치 i 의 원소. 없으면 프로그램이 멈춤 (a[i] 만 쓰면
--                   015 의 List.head 처럼 i < a.size 라는 증명이 필요)
--   a.modify i f    위치 i 의 원소에 f 를 적용한 a
--   Array.replicate n x     x 를 n 개
--
-- 값은 바뀌지 않으므로 a.push x 는 새 배열입니다. 하지만 a 를 더 쓰는
-- 곳이 없으면 Lean 은 그 메모리를 다시 씁니다. 그래서 push 를 반복하는
-- 것은 명령형 언어만큼 빠릅니다.
--
-- squaresArray (반복문 안에서 push 로), get (i 가 범위 밖이면 0),
-- histogram (buckets 보다 작은 각 수가 xs 에 몇 번 나오는지. buckets
-- 이상인 수는 무시) 을 채우세요.

def squaresArray (n : Nat) : Array Nat := sorry

#guard squaresArray 4 == #[0, 1, 4, 9]
#guard squaresArray 0 == #[]

def get (a : Array Nat) (i : Nat) : Nat := sorry

#guard get #[10, 20] 1 == 20
#guard get #[10, 20] 5 == 0

def histogram (xs : List Nat) (buckets : Nat) : Array Nat := sorry

#guard histogram [0, 1, 1, 3, 1] 4 == #[1, 3, 0, 1]
#guard histogram [5, 0] 2 == #[1, 0]
