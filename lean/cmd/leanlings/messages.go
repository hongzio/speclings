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
	Checking, NeedsFix, Printed          string
	Result, Expected, Hint, File, Cont   string // Cont: indentation for continuation lines of multi-line values
	HintHow, HintFor                     string
	AllDone, WatchWaiting, Fallback      string
	ProgressReset, Restored, BackedUp    string
	LangSet, LangKeep, UnknownLang       string
	OutOfRange, NoLean, NoChecker        string
	VersionMismatch                      string
	ProbErrors, ProbSorry, ProbSorryRun  string
	ProbTimeout                          string
	ProbGuard, ProbForbid, ProbReference string
	ProbOutput, ProbRunFailed            string
	ProbRunTimeout                       string
	RefMissing, RefKind, RefStatement    string
	RefDefinition, RefAxioms, RefBroken  string
	NoMessages, Nothing                  string
	ExpectFix, ExpectFill, ExpectForbid  string
	ExpectOutput                         string

	// -verify
	VerifyWrongFailure, VerifyNoSnippet     string
	VerifyCodeDiffers, VerifyMissing        string
	VerifyOriginalPasses, VerifyEmptyPasses string
	VerifyGuardMsgs, VerifyVersions         string
	VerifySolution, VerifyCoverage          string
	VerifyAllOK, VerifyFailed               string
}

var en = messages{
	Checking: "Checking",
	NeedsFix: "%s needs fixing.",
	Printed:  "The program printed:",
	Result:   "result:   ",
	Expected: "expected: ",
	Hint:     "hint:     ",
	HintHow:  "run %s",
	HintFor:  "Hint for %s:",
	File:     "file:     ",
	Cont:     "            ",

	AllDone:         "All exercises solved!",
	WatchWaiting:    "Save a file to check again. (Ctrl-C to quit)",
	Fallback:        "(not translated yet; using the English version)",
	ProgressReset:   "Progress cleared. The next run starts from 001.",
	Restored:        "%s: restored to its original state.",
	BackedUp:        "Your previous version is in %s",
	LangSet:         "Language: %s",
	LangKeep:        "Exercises already in work/ keep their language. Use -restore N to get one again.",
	UnknownLang:     "unknown language %q (available: %s)",
	OutOfRange:      "exercises are numbered 1..%d",
	NoLean:          "cannot run lean. Are you inside the mise environment? (%v)",
	NoChecker:       "cannot find the checker %s. Run leanlings as bin/leanlings, which builds it.",
	VersionMismatch: "warning: lean is version %s, but lean-toolchain asks for %s. Lean's messages may differ from what the exercises expect; run mise install.",

	ProbErrors:     "Lean reported %d error(s). Start with the first one",
	ProbSorry:      "there is still a sorry to replace",
	ProbSorryRun:   "there is still a sorry to replace. #guard and #eval cannot run code with sorry, so they report errors until it is gone",
	ProbTimeout:    "Lean did not finish within %s. Is there a recursion or a proof search that never ends?",
	ProbGuard:      "Lean is happy, but a #guard of the original is missing or changed.\nKeep every original #guard; adding your own is fine:\n%s",
	ProbForbid:     "Lean is happy, but this exercise asks you to do without %s",
	ProbReference:  "Lean is happy, but the file no longer matches the exercise:\n%s",
	ProbOutput:     "the program printed\n%s\nbut should print\n%s",
	ProbRunFailed:  "the program stopped with exit code %d",
	ProbRunTimeout: "the program did not finish within %s",
	RefMissing:     "%s was removed",
	RefKind:        "%s changed kind (%s)",
	RefStatement:   "the statement of %s changed. Prove it as stated",
	RefDefinition:  "the given definition %s changed. Only the sorry parts are yours to fill in",
	RefAxioms:      "%s depends on %s. Axioms you add and native_decide are not proofs",
	RefBroken:      "%s: the reference (the original without comments and # commands) does not compile: %s",
	NoMessages:     "no messages",
	Nothing:        "(nothing)",

	ExpectFix:    "no errors and no sorry",
	ExpectFill:   "no errors and no sorry, with the given definitions and statements unchanged",
	ExpectForbid: ", without %s",
	ExpectOutput: ", and the program prints %q",

	VerifyWrongFailure:   "fails for another reason: %s",
	VerifyNoSnippet:      "snippet not found: %q",
	VerifyCodeDiffers:    "code differs from en: %s",
	VerifyMissing:        "not translated (falls back to en)",
	VerifyOriginalPasses: "the original passes the check",
	VerifyEmptyPasses:    "an empty file passes the check: use fill(), or add a #guard that uses the exercise's definitions",
	VerifyGuardMsgs:      "uses #guard_msgs, whose expected output is a comment and would be translated; use #guard",
	VerifyVersions:       "Lean versions disagree: lean %s, lean-toolchain %s, mise.toml %s",
	VerifySolution:       "solution",
	VerifyCoverage:       "%s: %d/%d translated",
	VerifyAllOK:          "All %d exercises are OK.",
	VerifyFailed:         "%d of %d exercises have problems.",
}

var ko = messages{
	Checking: "검사 중",
	NeedsFix: "고쳐야 합니다: %s",
	Printed:  "프로그램 출력:",
	Result:   "결과: ",
	Expected: "기대: ",
	Hint:     "힌트: ",
	HintHow:  "%s 로 볼 수 있습니다",
	HintFor:  "%s 힌트:",
	File:     "파일: ",
	Cont:     "        ",

	AllDone:         "모든 문제를 풀었습니다!",
	WatchWaiting:    "저장하면 다시 검사합니다. (Ctrl-C 로 종료)",
	Fallback:        "(아직 번역되지 않아 영어판을 씁니다)",
	ProgressReset:   "진도를 지웠습니다. 다음 실행은 001 부터 검사합니다.",
	Restored:        "원래 상태로 되돌렸습니다: %s",
	BackedUp:        "이전 파일: %s",
	LangSet:         "언어: %s",
	LangKeep:        "work/ 에 이미 있는 문제는 원래 언어 그대로입니다. 다시 받으려면 -restore N 을 쓰세요.",
	UnknownLang:     "알 수 없는 언어 %q (가능: %s)",
	OutOfRange:      "문제는 1..%d 번까지 있습니다",
	NoLean:          "lean 을 실행할 수 없습니다. mise 환경에서 실행했나요? (%v)",
	NoChecker:       "검사기를 찾을 수 없습니다: %s. leanlings 는 검사기를 빌드하는 bin/leanlings 로 실행하세요.",
	VersionMismatch: "경고: lean 버전은 %s 인데 lean-toolchain 은 %s 입니다. 문제가 기대하는 것과 Lean 메시지가 다를 수 있습니다. mise install 을 실행하세요.",

	ProbErrors:     "Lean 이 에러 %d 개를 보고했습니다. 첫 번째 에러부터 보세요",
	ProbSorry:      "아직 바꿔야 할 sorry 가 있습니다",
	ProbSorryRun:   "아직 바꿔야 할 sorry 가 있습니다. #guard 와 #eval 은 sorry 가 든 코드를 실행할 수 없어서, sorry 가 없어질 때까지 에러를 냅니다",
	ProbTimeout:    "Lean 이 %s 안에 끝나지 않았습니다. 끝나지 않는 재귀나 증명 탐색이 있나요?",
	ProbGuard:      "Lean 은 통과했지만 원본의 #guard 가 없어졌거나 바뀌었습니다.\n원본 #guard 는 모두 남겨 두세요 (새 #guard 를 더하는 건 괜찮습니다):\n%s",
	ProbForbid:     "Lean 은 통과했지만 이 문제는 다음 없이 풀어야 합니다: %s",
	ProbReference:  "Lean 은 통과했지만 파일이 문제와 달라졌습니다:\n%s",
	ProbOutput:     "프로그램 출력:\n%s\n기대한 출력:\n%s",
	ProbRunFailed:  "프로그램이 실패로 끝났습니다 (exit code %d)",
	ProbRunTimeout: "프로그램이 %s 안에 끝나지 않았습니다",
	RefMissing:     "지워졌습니다: %s",
	RefKind:        "선언의 종류가 바뀌었습니다: %s (%s)",
	RefStatement:   "정리의 명제가 바뀌었습니다: %s. 주어진 그대로 증명하세요",
	RefDefinition:  "주어진 정의가 바뀌었습니다: %s. 채울 것은 sorry 부분뿐입니다",
	RefAxioms:      "%s 의 증명이 다음 공리에 기댑니다: %s. 직접 추가한 공리나 native_decide 는 증명이 아닙니다",
	RefBroken:      "%s: 기준(주석과 # 명령을 뺀 원본)이 컴파일되지 않습니다: %s",
	NoMessages:     "메시지 없음",
	Nothing:        "(없음)",

	ExpectFix:    "에러 없음, sorry 없음",
	ExpectFill:   "에러 없음, sorry 없음, 주어진 정의와 명제는 그대로",
	ExpectForbid: ", 다음 없이: %s",
	ExpectOutput: ", 프로그램 출력 %q",

	VerifyWrongFailure:   "다른 이유로 실패: %s",
	VerifyNoSnippet:      "코드 조각을 찾을 수 없음: %q",
	VerifyCodeDiffers:    "en 과 코드가 다름: %s",
	VerifyMissing:        "번역 없음 (en 으로 대체)",
	VerifyOriginalPasses: "원본이 검사를 통과함",
	VerifyEmptyPasses:    "빈 파일이 검사를 통과함: fill() 을 쓰거나, 문제의 정의를 쓰는 #guard 를 더하세요",
	VerifyGuardMsgs:      "#guard_msgs 는 기대 출력이 주석이라 번역될 수 있으니 #guard 를 쓰세요",
	VerifyVersions:       "Lean 버전이 다름: lean %s, lean-toolchain %s, mise.toml %s",
	VerifySolution:       "정답",
	VerifyCoverage:       "%s: %d/%d 번역됨",
	VerifyAllOK:          "%d 개 문제 모두 정상입니다.",
	VerifyFailed:         "%d/%d 개 문제에 문제가 있습니다.",
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
