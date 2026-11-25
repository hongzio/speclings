package track

import "github.com/hongzio/speclings/internal/lings"

// messages is one set of what the Lean track reports; the engine (internal/lings) has
// the rest. To add a language, add a value of this type to catalogs (and to the engine's).
// messages_test.go catches empty fields and fmt verbs (%d, %s, ...) that differ from en.
//
// In Korean text, never put a particle (이/가/을/를) right after %s: the correct one depends on the word it follows.
type messages struct {
	Printed                              string
	NoLean, NoChecker, CheckerBuild      string
	VersionMismatch                      string
	ProbErrors, ProbSorry, ProbSorryRun  string
	ProbTimeout                          string
	ProbDeepRecursion, ProbCrash         string
	MoreFrames, MoreLines                string
	ProbGuard, ProbForbid, ProbReference string
	ProbOutput, ProbRunFailed            string
	ProbRunTimeout                       string
	RefMissing, RefKind, RefStatement    string
	RefDefinition, RefAxioms, RefBroken  string
	NoMessages, Nothing                  string
	ExpectFix, ExpectFill, ExpectForbid  string
	ExpectOutput                         string

	// -verify
	VerifyOriginalPasses, VerifyEmptyPasses string
	VerifyGuardMsgs, VerifyVersions         string
	VerifyMissingFailure                    string
}

var en = messages{
	Printed: "The program printed:",

	NoLean:          "cannot run lean. Are you inside the mise environment? (%v)",
	NoChecker:       "cannot find the checker %s. speclings lean builds it before checking.",
	CheckerBuild:    "cannot build the checker in lean/checker/ (lake build): %v",
	VersionMismatch: "warning: lean is version %s, but lean-toolchain asks for %s. Lean's messages may differ from what the exercises expect; run mise install.",

	ProbErrors:   "Lean reported %d error(s). Start with the first one",
	ProbSorry:    "there is still a sorry to replace",
	ProbSorryRun: "there is still a sorry to replace. #guard and #eval cannot run code with sorry, so they report errors until it is gone",
	ProbTimeout:  "Lean did not finish within %s. Is there a recursion or a proof search that never ends?",
	ProbDeepRecursion: "Lean stopped while running your code (#guard, #eval or main) because a recursion went too deep; the messages after that point are missing.\n" +
		"Does a function call itself without getting any closer to a base case?",
	ProbCrash:      "Lean stopped unexpectedly (%s); the messages after that point are missing. Start with the first one",
	MoreFrames:     "… %d more frames",
	MoreLines:      "… %d more lines",
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

	VerifyOriginalPasses: "the original passes the check",
	VerifyEmptyPasses:    "an empty file passes the check: use fill(), or add a #guard that uses the exercise's definitions",
	VerifyGuardMsgs:      "uses #guard_msgs, whose expected output is a comment and would be translated; use #guard",
	VerifyVersions:       "Lean versions disagree: lean %s, lean-toolchain %s, mise.toml %s",
	VerifyMissingFailure: "lacks an intended failure: %s",
}

var ko = messages{
	Printed: "프로그램 출력:",

	NoLean:          "lean 을 실행할 수 없습니다. mise 환경에서 실행했나요? (%v)",
	NoChecker:       "검사기를 찾을 수 없습니다: %s. speclings lean 이 검사 전에 빌드합니다.",
	CheckerBuild:    "lean/checker/ 의 검사기를 빌드할 수 없습니다 (lake build): %v",
	VersionMismatch: "경고: lean 버전은 %s 인데 lean-toolchain 은 %s 입니다. 문제가 기대하는 것과 Lean 메시지가 다를 수 있습니다. mise install 을 실행하세요.",

	ProbErrors:   "Lean 이 에러 %d 개를 보고했습니다. 첫 번째 에러부터 보세요",
	ProbSorry:    "아직 바꿔야 할 sorry 가 있습니다",
	ProbSorryRun: "아직 바꿔야 할 sorry 가 있습니다. #guard 와 #eval 은 sorry 가 든 코드를 실행할 수 없어서, sorry 가 없어질 때까지 에러를 냅니다",
	ProbTimeout:  "Lean 이 %s 안에 끝나지 않았습니다. 끝나지 않는 재귀나 증명 탐색이 있나요?",
	ProbDeepRecursion: "Lean 이 코드를 실행하다가 (#guard, #eval 이나 main) 재귀가 너무 깊어져 멈췄습니다. 그 뒤의 메시지는 빠져 있습니다.\n" +
		"기저 사례에 가까워지지 않은 채 자신을 부르는 함수가 있나요?",
	ProbCrash:      "Lean 이 예기치 않게 멈췄습니다 (%s). 그 뒤의 메시지는 빠져 있습니다. 첫 번째 메시지부터 보세요",
	MoreFrames:     "… 프레임 %d 개 생략",
	MoreLines:      "… %d 줄 생략",
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

	VerifyOriginalPasses: "원본이 검사를 통과함",
	VerifyEmptyPasses:    "빈 파일이 검사를 통과함: fill() 을 쓰거나, 문제의 정의를 쓰는 #guard 를 더하세요",
	VerifyGuardMsgs:      "#guard_msgs 는 기대 출력이 주석이라 번역될 수 있으니 #guard 를 쓰세요",
	VerifyVersions:       "Lean 버전이 다름: lean %s, lean-toolchain %s, mise.toml %s",
	VerifyMissingFailure: "의도한 실패가 없음: %s",
}

const baseLang = lings.BaseLang

var catalogs = map[string]*messages{"en": &en, "ko": &ko}

// m holds the messages for the current language; SetLang switches it.
var m = catalogs[baseLang]

// L is a string per language, e.g. a hint.
type L = lings.L
