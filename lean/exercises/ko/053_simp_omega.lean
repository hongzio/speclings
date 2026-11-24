-- speclings lean 053: simp 와 omega
--
-- 이제 많은 증명의 단계를 손으로 밟아 보았습니다. 그 대부분을 대신 해
-- 주는 전술이 둘 있고, 이제부터는 받아들입니다:
--
--   omega        Nat 과 Int 의 선형 산술 목표를 증명합니다. +, -, 상수 곱,
--                <, ≤, = 와 그것들을 둘러싼 논리를, 가정들을 써서
--   simp         simp 정리들로 목표를 계속 다시 씁니다. 그중 많은 것이
--                Lean 에 들어 있습니다. 끝나거나 막힐 때까지
--   simp [f, h]  정의 f 도 펼치고 h 로도 다시 씀
--   simp [*]     ih 같은 모든 가정으로도 다시 씀
--
-- simp 가 산술 목표를 남기면 omega 가 마무리할 때가 많습니다:
-- simp [...]; omega. 직접 증명한 정리를 simp 가 쓰게 하려면 아래
-- append_nil 처럼 @[simp] 를 붙이세요.
--
-- 전술 결합자도 도움이 됩니다. t1 <;> t2 는 t1 이 남긴 모든 목표에 t2 를
-- 실행하므로, induction xs <;> simp [append, *] 는 두 경우를 한 번에
-- 처리합니다.
--
-- simp 와 omega 로 증명하세요. (grind 와 exact? 같은 검색 전술은 아직
-- 받아들이지 않습니다.)

def append {α : Type} : List α → List α → List α
  | [], ys => ys
  | x :: xs, ys => x :: append xs ys

def len {α : Type} : List α → Nat
  | [] => 0
  | _ :: xs => len xs + 1

theorem shuffle (a b c d : Nat) (h1 : a < b) (h2 : c ≤ d) : a + c < b + d + 1 := by
  sorry

theorem reverse_sum (a b c : Nat) : a + b + c = c + b + a := by
  sorry

theorem len_append {α : Type} (xs ys : List α) : len (append xs ys) = len xs + len ys := by
  sorry

@[simp] theorem append_nil {α : Type} (xs : List α) : append xs [] = xs := by
  sorry

theorem len_append_nil (xs : List Nat) : len (append xs []) = len xs := by
  sorry
