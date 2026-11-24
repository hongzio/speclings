-- speclings lean 046: calc (solution)

theorem lt_chain (a b c d : Nat) (h1 : a = b) (h2 : b ≤ c) (h3 : c < d) : a < d :=
  calc a = b := h1
    _ ≤ c := h2
    _ < d := h3

theorem double_double (a b : Nat) (h : a = 2 * b) : a + a = 4 * b :=
  calc a + a = 2 * b + 2 * b := by rw [h]
    _ = (2 + 2) * b := (Nat.add_mul 2 2 b).symm
    _ = 4 * b := rfl
