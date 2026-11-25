-- speclings lean 059: debugging induction
--
-- Each proof below fails, and the messages say why. Read them before you
-- change anything:
--
--   omega could not prove the goal    omega lists the facts it used and a
--        counterexample to them. A term such as lenAcc xs (acc + 1) that it
--        treats as an unknown number is a hint: no fact says what it is.
--   This simp argument is unused      a lemma you gave simp did not fit
--        anywhere. An unused ih means it is about the wrong thing (056).
--   simp made no progress             no simp lemma applies: simp does not
--        know your definitions or theorems until you name them
--   Failed to rewrite using equation theorems for f    rw [f] needs the
--        argument in the shape of a case of f, such as n + 1; split into
--        cases first (cases n)
--
-- omega only sees arithmetic: a definition such as IsEven is a word it
-- does not know, so unfold it first (unfold IsEven at *).
--
-- Fix each proof; keep the statements. grind and the search tactics are
-- still not accepted.

def lenAcc : List Nat → Nat → Nat
  | [], acc => acc
  | _ :: xs, acc => lenAcc xs (acc + 1)

theorem lenAcc_eq (xs : List Nat) (acc : Nat) : lenAcc xs acc = acc + xs.length := by
  induction xs with
  | nil => simp [lenAcc]
  | cons x xs ih => simp [lenAcc, ih]; omega

theorem lenAcc_zero (xs : List Nat) : lenAcc xs 0 = xs.length := by simp

def double : Nat → Nat
  | 0 => 0
  | n + 1 => double n + 2

theorem double_pos (n : Nat) (h : 0 < n) : 0 < double n := by
  rw [double]
  omega

def IsEven (n : Nat) : Prop := n % 2 = 0

theorem even_add_two (n : Nat) (h : IsEven n) : IsEven (n + 2) := by omega
