-- leanlings 063: invariants (solution)

structure Range where
  lo : Nat
  hi : Nat
  ok : lo ≤ hi

namespace Range

def length (r : Range) : Nat := r.hi - r.lo

def make (a b : Nat) : Range :=
  if h : a ≤ b then ⟨a, b, h⟩ else ⟨b, a, by omega⟩

def widen (r : Range) (k : Nat) : Range := ⟨r.lo, r.hi + k, by have := r.ok; omega⟩

def shift (r : Range) (k : Nat) : Range := ⟨r.lo + k, r.hi + k, by have := r.ok; omega⟩

theorem length_widen (r : Range) (k : Nat) : (r.widen k).length = r.length + k := by
  have := r.ok
  simp only [widen, length]
  omega

theorem length_shift (r : Range) (k : Nat) : (r.shift k).length = r.length := by
  simp only [shift, length]
  omega

end Range

#guard (Range.make 7 3).lo == 3
#guard (Range.make 7 3).length == 4
#guard (Range.make 2 5).length == 3
#guard ((Range.make 2 5).widen 10).length == 13
#guard ((Range.make 2 5).shift 10).lo == 12
