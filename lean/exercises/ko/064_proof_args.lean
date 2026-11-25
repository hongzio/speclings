-- speclings lean 064: 인자로 받는 증명
--
-- 015 에서 List.head 가 리스트가 비어 있지 않다는 증명을 요구하는 것을
-- 보았습니다:
--
--   List.head : (xs : List α) → xs ≠ [] → α
--
-- 직접 만든 함수도 Option 을 돌려주는 대신 같은 방법으로 증명을 요구할 수
-- 있습니다. 그러면 함수는 절대 실패하지 않고, 입력이 괜찮다는 것은
-- 호출하는 쪽이 보여야 합니다:
--
--   firstAndLast [3, 1, 4] (by simp)
--
-- 그런 증명을 가진 함수는 그것을 넘겨주거나, 그것으로 새 증명을 만들 수
-- 있습니다. h : xs.length > 5 가 있으면 xs.length ≥ 2 의 증명은
-- (by omega) 입니다. 그리고 xs[i] 를 읽을 때 Lean 은 i 가 충분히 작다는
-- 증명을 가정들에서 찾습니다.
--
-- 여기서 쓸모 있는 것: h : xs ≠ [] 에 대해 xs.head h 와 xs.getLast h.

def firstAndLast (xs : List Nat) (h : xs ≠ []) : Nat × Nat := sorry

#guard firstAndLast [3, 1, 4] (by simp) == (3, 4)

def second (xs : List Nat) (h : xs.length ≥ 2) : Nat := sorry

#guard second [5, 6, 7] (by decide) == 6

def middle (xs : List Nat) (h : xs.length > 0) : Nat := sorry

#guard middle [1, 2, 3] (by decide) == 2

-- second 를 쓰세요
def secondOfLong (xs : List Nat) (h : xs.length > 5) : Nat := sorry

#guard secondOfLong [1, 2, 3, 4, 5, 6] (by decide) == 2
