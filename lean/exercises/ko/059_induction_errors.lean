-- speclings lean 059: 귀납 증명 디버깅
--
-- 아래 증명들은 실패하고, 메시지가 이유를 말해 줍니다. 무엇이든 바꾸기
-- 전에 먼저 읽으세요:
--
--   omega could not prove the goal    omega 는 쓴 사실들과 그것들에 대한
--        반례를 보여 줍니다. lenAcc xs (acc + 1) 처럼 모르는 수로 다룬 항이
--        단서입니다. 그것이 무엇인지 말해 주는 사실이 없다는 뜻입니다.
--   This simp argument is unused      simp 에 준 정리가 어디에도 맞지
--        않았습니다. ih 가 쓰이지 않았다면 엉뚱한 것에 관한 ih 입니다 (056).
--   simp made no progress             쓸 수 있는 simp 정리가 없습니다. simp
--        는 이름을 대기 전까지 여러분의 정의나 정리를 모릅니다
--   Failed to rewrite using equation theorems for f    rw [f] 는 인자가 f
--        의 한 경우의 모양(n + 1 같은)이어야 합니다. 먼저 경우를 나누세요
--        (cases n)
--
-- omega 는 산술만 봅니다. IsEven 같은 정의는 모르는 단어이니 먼저
-- 펼치세요 (unfold IsEven at *).
--
-- 명제는 그대로 두고 증명을 고치세요. grind 와 검색 전술은 아직 받아들이지
-- 않습니다.

def lenAcc : List Nat → Nat → Nat
  | [], acc => acc
  | _ :: xs, acc => lenAcc xs (acc + 1)

theorem lenAcc_eq (xs : List Nat) (acc : Nat) : lenAcc xs acc = acc + xs.length := by
  induction xs with
  | nil => simp [lenAcc]
  | cons x xs ih => simp [lenAcc, ih]; omega

theorem lenAcc_zero (xs : List Nat) : lenAcc xs 0 = xs.length := by simp

def double : Nat → Nat
  | 0 => 0
  | n + 1 => double n + 2

theorem double_pos (n : Nat) (h : 0 < n) : 0 < double n := by
  rw [double]
  omega

def IsEven (n : Nat) : Prop := n % 2 = 0

theorem even_add_two (n : Nat) (h : IsEven n) : IsEven (n + 2) := by omega
