-- leanlings 046: calc
--
-- A proof on paper often reads a = b = c ≤ d. calc writes it the same
-- way, each step with its own proof:
--
--   calc a = b := h1
--     _ ≤ c := h2          -- _ stands for the right side of the step above
--     _ < d := h3
--
-- Lean then combines the steps: here, a < d. Each proof can be a term, or
-- by followed by tactics, such as by rw [h].
--
-- Useful here: Nat.add_mul a b c : (a + b) * c = a * c + b * c. (e.symm
-- turns a proof e of x = y into a proof of y = x.) And rfl proves that
-- (2 + 2) * b = 4 * b: 2 + 2 computes to 4.

theorem lt_chain (a b c d : Nat) (h1 : a = b) (h2 : b ≤ c) (h3 : c < d) : a < d :=
  sorry

theorem double_double (a b : Nat) (h : a = 2 * b) : a + a = 4 * b :=
  sorry
