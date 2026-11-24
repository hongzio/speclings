-- speclings lean 063: 불변식
--
-- structure 는 증명을 필드로 가질 수 있습니다. 아래 Range 는 구간
-- lo .. hi 와 lo ≤ hi 라는 증명을 함께 담습니다. 그래서 거꾸로 된 Range 는
-- 없습니다. 만드는 쪽이 증명해야 하니까요.
--
-- make 는 두 수를 아무 순서로나 받습니다. Range 를 만들려면 어느 쪽이 더
-- 작은지를 가정으로 알아야 합니다. 062 의 의존 if 가 갈래마다 그것을
-- 줍니다.
--
--   if h : a ≤ b then ⟨a, b, h⟩ else ...    -- else 갈래에서는 h : ¬a ≤ b
--
-- 불변식은 증명에도 도움이 됩니다. length_widen 에서 r.hi - r.lo 는 Nat
-- 뺄셈이고, omega 는 r.lo ≤ r.hi 를 알 때만 이것을 다룰 수 있습니다.
-- have := r.ok 가 그것을 알려 줍니다.

structure Range where
  lo : Nat
  hi : Nat
  ok : lo ≤ hi

namespace Range

def length (r : Range) : Nat := r.hi - r.lo

def make (a b : Nat) : Range := sorry

def widen (r : Range) (k : Nat) : Range := sorry

def shift (r : Range) (k : Nat) : Range := sorry

theorem length_widen (r : Range) (k : Nat) : (r.widen k).length = r.length + k := by
  sorry

theorem length_shift (r : Range) (k : Nat) : (r.shift k).length = r.length := by
  sorry

end Range

#guard (Range.make 7 3).lo == 3
#guard (Range.make 7 3).length == 4
#guard (Range.make 2 5).length == 3
#guard ((Range.make 2 5).widen 10).length == 13
#guard ((Range.make 2 5).shift 10).lo == 12
