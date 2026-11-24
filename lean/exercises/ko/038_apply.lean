-- leanlings 038: apply
--
-- exact 는 증명 전체를 한 번에 요구합니다. apply 는 반대로 거꾸로
-- 나아갑니다. 목표가 s 이고 h3 : r → s 가 있으면, apply h3 은 r 을 증명할
-- 것으로 남깁니다. 목표에서 가진 것 쪽으로 한 걸음씩 거슬러 갑니다.
--
-- h : p → q → r 이 있고 목표가 r 이면, apply h 는 p 와 q 두 목표를
-- 남깁니다. 각각을 · 다음에 차례로 증명하세요.
--
-- assumption 은 가정 중 하나와 정확히 같은 목표를, 이름을 대지 않고
-- 닫습니다.
--
-- apply, exact, assumption 으로 증명하세요.

theorem chain (p q r s : Prop) (h1 : p → q) (h2 : q → r) (h3 : r → s) (hp : p) : s := by
  sorry

theorem two_premises (p q r : Prop) (h : p → q → r) (hp : p) (hq : q) : r := by
  sorry

theorem pick (p q r : Prop) (hq : q) (h : q → r) (_ : p) : r := by
  sorry
