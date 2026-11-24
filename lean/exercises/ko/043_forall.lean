-- speclings lean 043: 모든
--
-- 명제가 값에 따라 달라질 수 있습니다. 아래 Even 은 술어입니다. 각 n 에
-- 대해 Even n 은 명제이고, n % 2 = 0 일 때 성립합니다. Even 4 는 계산으로
-- 성립하므로 rfl 이 증명합니다.
--
-- ∀ x, P x ("모든 x 에 대해 P x", ∀ 는 \forall 로 입력) 는 함의처럼
-- 증명합니다. 그 증명은 아무 x 나 받아 P x 의 증명을 주는 함수입니다.
-- 그래서 intro x 로 증명을 시작하고, h : ∀ n, P n 을 5 에 적용한 h 5 는
-- P 5 의 증명입니다.
--
-- (all_imp 의 α 는 024 에서처럼 아무 타입이고, P 와 Q 는 그 위의
-- 술어입니다.)

def Even (n : Nat) : Prop := n % 2 = 0

theorem even_four : Even 4 := rfl

theorem all_imp {α : Type} (P Q : α → Prop) (h1 : ∀ x, P x → Q x) (h2 : ∀ x, P x) : ∀ x, Q x := by
  sorry

theorem two_instances (P : Nat → Prop) (h : ∀ n, P n) : P 5 ∧ P 7 := sorry

theorem forall_and_split {α : Type} (P Q : α → Prop) : (∀ x, P x ∧ Q x) → (∀ x, P x) ∧ (∀ x, Q x) := by
  sorry

theorem even_add_two (h : ∀ n, Even n → Even (n + 2)) : Even 6 := sorry
