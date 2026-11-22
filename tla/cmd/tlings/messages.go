package main

import (
	"maps"
	"slices"
	"strings"
)

// messages is one set of the runner's output text. To add a language, add a
// value of this type to catalogs and create exercises/<lang>/.
// messages_test.go catches empty fields and fmt verbs (%d, %s, ...) that differ from en.
//
// In Korean text, never put a particle (이/가/을/를) right after %s: the correct one depends on the word it follows.
type messages struct {
	// learner flow
	Checking, NeedsFix                  string
	Result, Expected, Hint, File, Cont  string // Cont: indentation for continuation lines of multi-line values
	AllDone, WatchWaiting, Fallback     string
	ProgressReset, Restored, BackedUp   string
	LangSet, LangKeep, UnknownLang      string
	OutOfRange, NoTLC                   string
	ExitOK, ExitAssume, ExitDeadlock    string
	ExitSafety, ExitLiveness, ExitParse string
	ExitConfig, ExitOther               string
	WrongStates, WrongInvariant         string
	WrongTraceLen                       string
	ExpectNoError, ExpectStates         string
	ExpectViolation, ExpectDeadlock     string

	// -verify
	VerifyWrongFailure, VerifyNoSnippet string
	VerifyCodeDiffers, VerifyMissing    string
	VerifySolution, VerifyCoverage      string
	VerifyAllOK, VerifyFailed           string
}

var en = messages{
	Checking: "Checking",
	NeedsFix: "%s needs fixing.",
	Result:   "result:   ",
	Expected: "expected: ",
	Hint:     "hint:     ",
	File:     "file:     ",
	Cont:     "            ",

	AllDone:       "All exercises solved!",
	WatchWaiting:  "Save a file to check again. (Ctrl-C to quit)",
	Fallback:      "(not translated yet; using the English version)",
	ProgressReset: "Progress cleared. The next run starts from 001.",
	Restored:      "%s: restored to its original state.",
	BackedUp:      "Your previous version is in %s",
	LangSet:       "Language: %s",
	LangKeep:      "Exercises already in work/ keep their language. Use -restore N to get one again.",
	UnknownLang:   "unknown language %q (available: %s)",
	OutOfRange:    "exercises are numbered 1..%d",
	NoTLC:         "cannot run tlc. Are you inside the mise environment? (%v)",

	ExitOK:       "TLC finished with no errors",
	ExitAssume:   "an ASSUME is false",
	ExitDeadlock: "deadlock (counterexample length %d)",
	ExitSafety:   "invariant %s is violated (counterexample length %d)",
	ExitLiveness: "a temporal property (PROPERTY) is violated",
	ExitParse:    "SANY could not read the spec (syntax or name error)",
	ExitConfig:   "the .cfg file has an error",
	ExitOther:    "TLC error (exit %d)",

	WrongStates: "TLC finished with no errors, but found %d distinct states (expected %d).\n" +
		"The spec explores a different state space than intended. Check whether Init or Next is too narrow or too wide.",
	WrongInvariant: "the violated invariant is %s, but the one that should be violated is %s.",
	WrongTraceLen:  "%s, but the counterexample length is %d (expected %d).",

	ExpectNoError:   "no errors",
	ExpectStates:    "no errors, %d distinct states",
	ExpectViolation: "invariant %s violated (counterexample length %d)",
	ExpectDeadlock:  "deadlock (counterexample length %d)",

	VerifyWrongFailure: "fails for another reason: %s",
	VerifyNoSnippet:    "snippet not found: %q",
	VerifyCodeDiffers:  "code differs from en: %s",
	VerifyMissing:      "not translated (falls back to en)",
	VerifySolution:     "solution",
	VerifyCoverage:     "%s: %d/%d translated",
	VerifyAllOK:        "All %d exercises are OK.",
	VerifyFailed:       "%d of %d exercises have problems.",
}

var ko = messages{
	Checking: "검사 중",
	NeedsFix: "고쳐야 합니다: %s",
	Result:   "결과: ",
	Expected: "기대: ",
	Hint:     "힌트: ",
	File:     "파일: ",
	Cont:     "        ",

	AllDone:       "모든 문제를 풀었습니다!",
	WatchWaiting:  "저장하면 다시 검사합니다. (Ctrl-C 로 종료)",
	Fallback:      "(아직 번역되지 않아 영어판을 씁니다)",
	ProgressReset: "진도를 지웠습니다. 다음 실행은 001 부터 검사합니다.",
	Restored:      "원래 상태로 되돌렸습니다: %s",
	BackedUp:      "이전 파일: %s",
	LangSet:       "언어: %s",
	LangKeep:      "work/ 에 이미 있는 문제는 원래 언어 그대로입니다. 다시 받으려면 -restore N 을 쓰세요.",
	UnknownLang:   "알 수 없는 언어 %q (가능: %s)",
	OutOfRange:    "문제는 1..%d 번까지 있습니다",
	NoTLC:         "tlc 를 실행할 수 없습니다. mise 환경에서 실행했나요? (%v)",

	ExitOK:       "TLC 가 에러 없이 끝났습니다",
	ExitAssume:   "ASSUME 이 거짓입니다",
	ExitDeadlock: "deadlock 입니다 (반례 길이 %d)",
	ExitSafety:   "불변식이 깨졌습니다: %s (반례 길이 %d)",
	ExitLiveness: "시간 속성(PROPERTY)이 깨졌습니다",
	ExitParse:    "SANY 가 스펙을 읽지 못했습니다 (문법/이름 오류)",
	ExitConfig:   ".cfg 파일에 오류가 있습니다",
	ExitOther:    "TLC 에러입니다 (exit %d)",

	WrongStates: "TLC 는 에러 없이 끝났지만 distinct state 가 %d 개입니다 (기대: %d).\n" +
		"스펙이 의도와 다른 상태 공간을 탐색하고 있습니다. Init 이나 Next 가 너무 좁거나 넓지 않은지 보세요.",
	WrongInvariant: "깨진 불변식: %s, 깨져야 하는 불변식: %s",
	WrongTraceLen:  "%s. 반례 길이가 %d 입니다 (기대: %d).",

	ExpectNoError:   "에러 없음",
	ExpectStates:    "에러 없음, distinct state %d 개",
	ExpectViolation: "불변식 위반: %s (반례 길이 %d)",
	ExpectDeadlock:  "deadlock (반례 길이 %d)",

	VerifyWrongFailure: "다른 이유로 실패: %s",
	VerifyNoSnippet:    "코드 조각을 찾을 수 없음: %q",
	VerifyCodeDiffers:  "en 과 코드가 다름: %s",
	VerifyMissing:      "번역 없음 (en 으로 대체)",
	VerifySolution:     "정답",
	VerifyCoverage:     "%s: %d/%d 번역됨",
	VerifyAllOK:        "%d 개 문제 모두 정상입니다.",
	VerifyFailed:       "%d/%d 개 문제에 문제가 있습니다.",
}

// baseLang is the default and reference language. Every exercise is written in it first,
// and the code in every other language must match it.
const baseLang = "en"

var catalogs = map[string]*messages{"en": &en, "ko": &ko}

// m holds the messages for the current language; main switches it to the workspace's language.
var m = catalogs[baseLang]

func languages() string {
	return strings.Join(slices.Sorted(maps.Keys(catalogs)), ", ")
}

// L is a string per language. Missing languages fall back to baseLang.
type L map[string]string

func (l L) in(lang string) string {
	if s := l[lang]; s != "" {
		return s
	}
	return l[baseLang]
}
