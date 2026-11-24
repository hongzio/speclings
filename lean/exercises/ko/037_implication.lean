-- speclings lean 037: 함의
--
-- Part 4 는 증명에 관한 Part 입니다. 004 에서 명제는 Prop 타입의
-- 타입이고, 명제의 증명은 그 타입의 값이라는 것을 보았습니다. "p 이면 q",
-- 곧 p → q 에 대해 이것이 뜻하는 바는 이렇습니다. p → q 의 증명은 p 의
-- 어떤 증명이든 q 의 증명으로 바꾸는 함수입니다.
--
--   theorem self_imp (p : Prop) : p → p := fun hp => hp
--
-- ("가정 p" 라는 뜻의 hp 같은 이름은 관습일 뿐입니다.) 전술 모드로는 같은
-- 증명을 이렇게 씁니다:
--
--   theorem self_imp (p : Prop) : p → p := by
--     intro hp      -- 목표 p → p 가 p 가 되고, hp : p 를 쓸 수 있음
--     exact hp      -- hp 가 바로 목표가 요구하는 것
--
-- intro 는 목표 p → q 의 p 를 가정으로 받고 q 를 증명할 것으로 남깁니다.
-- exact 는 목표의 증명으로 목표를 닫습니다. p → q 의 증명을 p 의 증명에
-- 적용하면 (hpq hp 처럼) q 의 증명이 됩니다.
--
-- 진행하면서 에디터에서 목표를 보세요. 무엇이 남았는지 보여 줍니다.
--
-- Part 4 에서는 자동 전술(simp, omega, decide, grind, trivial, exact? 등)을
-- 받아들이지 않습니다. 이 문제들은 그 전술들이 대신 해 줄 단계들을 직접
-- 밟아 보는 것이 목적입니다.

theorem self_imp (p : Prop) : p → p := sorry

theorem modus_ponens (p q : Prop) (hp : p) (hpq : p → q) : q := sorry

theorem imp_trans (p q r : Prop) (hpq : p → q) (hqr : q → r) : p → r := by
  sorry

theorem const_imp (p q : Prop) : p → q → p := by
  sorry
