-- speclings lean 068: quiz 6 (solution)

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

#guard find #[1, 3, 5, 7, 9] 7 == some 3
#guard find #[1, 3, 5, 7, 9] 1 == some 0
#guard find #[1, 3, 5, 7, 9] 9 == some 4
#guard find #[1, 3, 5, 7, 9] 4 == none
#guard find #[] 4 == none
