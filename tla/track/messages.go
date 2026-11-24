package track

import "github.com/hongzio/speclings/internal/lings"

// messages is one set of what the TLA+ track reports; the engine (internal/lings) has
// the rest. To add a language, add a value of this type to catalogs (and to the engine's).
// messages_test.go catches empty fields and fmt verbs (%d, %s, ...) that differ from en.
//
// In Korean text, never put a particle (이/가/을/를) right after %s: the correct one depends on the word it follows.
type messages struct {
	NoTLC                               string
	ExitOK, ExitAssume, ExitDeadlock    string
	ExitSafety, ExitProperty, ExitParse string
	ExitConfig, ExitOther               string
	ExitError, ExitTimeout              string
	WrongStates, WrongInvariant         string
	WrongTraceLen, MissingAssume        string
	ExpectNoError, ExpectStates         string
	ExpectViolation, ExpectDeadlock     string
	ExpectProperty                      string
}

var en = messages{
	NoTLC: "cannot run tlc. Are you inside the mise environment? (%v)",

	ExitOK:       "TLC finished with no errors",
	ExitAssume:   "an ASSUME is false",
	ExitDeadlock: "deadlock (counterexample length %d)",
	ExitSafety:   "invariant %s is violated (counterexample length %d)",
	ExitProperty: "property %s is violated",
	ExitParse:    "SANY could not read the spec (syntax or name error)",
	ExitConfig:   "the .cfg file has an error",
	ExitOther:    "TLC error (exit %d)",
	ExitError:    "TLC stopped with an error while evaluating the spec (see the Error lines above)",
	ExitTimeout:  "TLC did not finish within %s. The state space may be infinite: does some value grow without bound?",

	WrongStates: "TLC finished with no errors, but found %d distinct states (expected %d).\n" +
		"The spec explores a different state space than intended. Check whether Init or Next is too narrow or too wide.",
	WrongInvariant: "%s is violated, but the one that should be violated is %s.",
	WrongTraceLen:  "%s, but the counterexample length is %d (expected %d).",
	MissingAssume: "TLC passed, but an ASSUME from the original is missing or changed.\n" +
		"Keep every original ASSUME (only ??? may be replaced); adding your own is fine:\n%s",

	ExpectNoError:   "no errors",
	ExpectStates:    "no errors, %d distinct states",
	ExpectViolation: "invariant %s violated (counterexample length %d)",
	ExpectDeadlock:  "deadlock (counterexample length %d)",
	ExpectProperty:  "property %s violated",
}

var ko = messages{
	NoTLC: "tlc 를 실행할 수 없습니다. mise 환경에서 실행했나요? (%v)",

	ExitOK:       "TLC 가 에러 없이 끝났습니다",
	ExitAssume:   "ASSUME 이 거짓입니다",
	ExitDeadlock: "deadlock 입니다 (반례 길이 %d)",
	ExitSafety:   "불변식이 깨졌습니다: %s (반례 길이 %d)",
	ExitProperty: "속성이 깨졌습니다: %s",
	ExitParse:    "SANY 가 스펙을 읽지 못했습니다 (문법/이름 오류)",
	ExitConfig:   ".cfg 파일에 오류가 있습니다",
	ExitOther:    "TLC 에러입니다 (exit %d)",
	ExitError:    "TLC 가 스펙을 계산하다가 에러로 멈췄습니다 (위의 Error 줄을 보세요)",
	ExitTimeout:  "TLC 가 %s 안에 끝나지 않았습니다. 상태 공간이 무한할 수 있습니다. 끝없이 커지는 값이 있나요?",

	WrongStates: "TLC 는 에러 없이 끝났지만 distinct state 가 %d 개입니다 (기대: %d).\n" +
		"스펙이 의도와 다른 상태 공간을 탐색하고 있습니다. Init 이나 Next 가 너무 좁거나 넓지 않은지 보세요.",
	WrongInvariant: "깨진 것: %s, 깨져야 하는 것: %s",
	WrongTraceLen:  "%s. 반례 길이가 %d 입니다 (기대: %d).",
	MissingAssume: "TLC 는 통과했지만 원본의 ASSUME 이 없어졌거나 바뀌었습니다.\n" +
		"원본 ASSUME 은 모두 남겨 두세요 (??? 자리만 바꿀 수 있고, 새 ASSUME 을 더하는 건 괜찮습니다):\n%s",

	ExpectNoError:   "에러 없음",
	ExpectStates:    "에러 없음, distinct state %d 개",
	ExpectViolation: "불변식 위반: %s (반례 길이 %d)",
	ExpectDeadlock:  "deadlock (반례 길이 %d)",
	ExpectProperty:  "속성 위반: %s",
}

const baseLang = lings.BaseLang

var catalogs = map[string]*messages{"en": &en, "ko": &ko}

// m holds the messages for the current language; SetLang switches it.
var m = catalogs[baseLang]

// L is a string per language, e.g. a hint.
type L = lings.L
