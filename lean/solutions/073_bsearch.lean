-- speclings lean 073: binary search (solution)

def bsearch (a : Array Nat) (x : Nat) (lo hi : Nat) (h : hi ≤ a.size) : Option (Fin a.size) :=
  if hlt : lo < hi then
    let mid := (lo + hi) / 2
    if a[mid] = x then some ⟨mid, by omega⟩
    else if a[mid] < x then bsearch a x (mid + 1) hi h
    else bsearch a x lo mid (by omega)
  else none
termination_by hi - lo

def find (a : Array Nat) (x : Nat) : Option Nat :=
  (bsearch a x 0 a.size (Nat.le_refl _)).map (·.val)

theorem bsearch_sound (a : Array Nat) (x lo hi : Nat) (h : hi ≤ a.size) (i : Fin a.size)
    (hs : bsearch a x lo hi h = some i) : a[i] = x := by
  fun_induction bsearch a x lo hi h with
  | case1 => cases hs; simp_all
  | case2 => simp_all
  | case3 => simp_all
  | case4 => simp at hs

theorem find_sound (a : Array Nat) (x i : Nat) (h : find a x = some i) : a[i]? = some x := by
  unfold find at h
  cases hb : bsearch a x 0 a.size (Nat.le_refl _) with
  | none => simp [hb] at h
  | some j =>
    simp [hb] at h
    have := bsearch_sound a x 0 a.size (Nat.le_refl _) j hb
    grind
