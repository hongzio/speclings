-- speclings lean 042: if and only if
--
-- p ↔ q ("p if and only if q", type ↔ as \iff) holds when p and q imply
-- each other. A proof of it is a pair of implications:
--
--   ⟨fun hp => ..., fun hq => ...⟩ : p ↔ q
--   constructor          splits the goal p ↔ q into p → q and q → p
--   h.mp : p → q         the two directions of h : p ↔ q
--   h.mpr : q → p        ("modus ponens", and "reverse")
--
-- not_or_iff is one of De Morgan's laws.

theorem and_comm_iff (p q : Prop) : p ∧ q ↔ q ∧ p := by
  sorry

theorem not_or_iff (p q : Prop) : ¬(p ∨ q) ↔ ¬p ∧ ¬q := by
  sorry

theorem iff_use (p q : Prop) (h : p ↔ q) (hq : q) : p := sorry
