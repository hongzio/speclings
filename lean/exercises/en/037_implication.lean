-- speclings lean 037: implication
--
-- Part 4 is about proofs. In 004 you saw that a statement is a type, of
-- type Prop, and that a proof of it is a value of that type. Here is what
-- that means for "if p then q", written p → q: a proof of p → q is a
-- function that turns any proof of p into a proof of q.
--
--   theorem self_imp (p : Prop) : p → p := fun hp => hp
--
-- (Names like hp, for "hypothesis p", are only a habit.) In tactic mode,
-- the same proof reads:
--
--   theorem self_imp (p : Prop) : p → p := by
--     intro hp      -- the goal p → p becomes p, with hp : p available
--     exact hp      -- hp is exactly what the goal asks for
--
-- intro takes the p of a goal p → q as a hypothesis and leaves q to
-- prove. exact closes a goal with a proof of it. Applying a proof of
-- p → q to a proof of p, as in hpq hp, gives a proof of q.
--
-- Watch the goals in your editor as you go: they show what is left.
--
-- In Part 4, the automatic tactics (simp, omega, decide, grind, trivial,
-- exact? and the like) are not accepted: these exercises are about the
-- steps they would take for you.

theorem self_imp (p : Prop) : p → p := sorry

theorem modus_ponens (p q : Prop) (hp : p) (hpq : p → q) : q := sorry

theorem imp_trans (p q r : Prop) (hpq : p → q) (hqr : q → r) : p → r := by
  sorry

theorem const_imp (p q : Prop) : p → q → p := by
  sorry
