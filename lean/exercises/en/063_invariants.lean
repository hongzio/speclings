-- speclings lean 063: invariants
--
-- A structure can hold a proof as a field. A Range below is an interval
-- lo .. hi, together with a proof that lo ≤ hi. So no Range is ever
-- upside down: whoever builds one has to prove it.
--
-- make takes two numbers in any order. To build the Range, it needs to
-- know which is smaller, as a hypothesis: the dependent if, from 062,
-- gives it in each branch.
--
--   if h : a ≤ b then ⟨a, b, h⟩ else ...    -- in the else branch, h : ¬a ≤ b
--
-- The invariant also helps proofs. In length_widen, r.hi - r.lo is Nat
-- subtraction, which omega handles only when it knows that r.lo ≤ r.hi:
-- have := r.ok gives it that.

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
