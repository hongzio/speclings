-- speclings lean 058: indices (solution)

def third (xs : Array Nat) (h : 2 < xs.size) : Nat := xs[2]

#guard third #[10, 20, 30] (by decide) == 30

def lookup (a : Array String) (i : Fin a.size) : String := a[i]

def days : Array String := #["mon", "tue", "wed"]

#guard lookup days ⟨1, by decide⟩ == "tue"

#guard ((3 : Fin 5) + 4).val == 2
#guard (7 : Fin 5).val == 2
#guard (Fin.last 4).val == 4
