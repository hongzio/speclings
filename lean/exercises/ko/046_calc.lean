-- speclings lean 046: calc
--
-- 종이 위의 증명은 흔히 a = b = c ≤ d 처럼 읽힙니다. calc 는 같은 모양으로
-- 쓰고, 단계마다 증명을 붙입니다:
--
--   calc a = b := h1
--     _ ≤ c := h2          -- _ 는 윗 단계의 오른쪽을 뜻함
--     _ < d := h3
--
-- 그러면 Lean 이 단계들을 합칩니다. 여기서는 a < d 입니다. 각 증명은 항일
-- 수도 있고, by rw [h] 처럼 by 다음에 전술을 쓸 수도 있습니다.
--
-- 여기서 쓸모 있는 것: Nat.add_mul a b c : (a + b) * c = a * c + b * c.
-- (e.symm 은 x = y 의 증명 e 를 y = x 의 증명으로 바꿉니다.) 그리고 rfl 은
-- (2 + 2) * b = 4 * b 를 증명합니다. 2 + 2 는 계산하면 4 입니다.

theorem lt_chain (a b c d : Nat) (h1 : a = b) (h2 : b ≤ c) (h3 : c < d) : a < d :=
  sorry

theorem double_double (a b : Nat) (h : a = 2 * b) : a + a = 4 * b :=
  sorry
