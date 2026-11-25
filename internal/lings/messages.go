package lings

import (
	"maps"
	"reflect"
	"regexp"
	"slices"
	"strings"
)

// Messages is one set of the engine's output text. Each track has its own set for
// what only it reports. To add a language, add a value of this type to catalogs, one
// to every track's catalogs, and exercises/<lang>/ directories.
// CatalogProblems (run by the tests) catches empty fields and fmt verbs that differ from en.
//
// In Korean text, never put a particle (이/가/을/를) right after %s: the correct one depends on the word it follows.
type Messages struct {
	// learner flow
	Checking, NeedsFix                 string
	Result, Expected, Hint, File, Cont string // Cont: indentation for continuation lines of multi-line values
	HintHow, HintFor                   string
	AllDone, WatchWaiting, Fallback    string
	ProgressReset, Restored, BackedUp  string
	Renumbered                         string
	LangSet, LangKeep, UnknownLang     string
	OutOfRange, UnknownTrack           string

	// overview
	Intro, NextUp, TrackDone, HowTo string

	// -verify
	VerifyWrongFailure, VerifyNoSnippet string
	VerifyCodeDiffers, VerifyMissing    string
	VerifySolution, VerifyCoverage      string
	VerifyAllOK, VerifyFailed           string
}

var en = Messages{
	Checking: "Checking",
	NeedsFix: "%s needs fixing.",
	Result:   "result:   ",
	Expected: "expected: ",
	Hint:     "hint:     ",
	HintHow:  "run %s",
	HintFor:  "Hint for %s:",
	File:     "file:     ",
	Cont:     "            ",

	AllDone:       "All exercises solved!",
	WatchWaiting:  "Save a file to check again. (Ctrl-C to quit)",
	Fallback:      "(not translated yet; using the English version)",
	ProgressReset: "Progress cleared. The next run starts from 001.",
	Restored:      "%s: restored to its original state.",
	BackedUp:      "Your previous version is in %s",
	Renumbered:    "The exercises were renumbered: %s is now %s",
	LangSet:       "Language: %s",
	LangKeep:      "Exercises already in work/ keep their language. Use -restore N to get one again.",
	UnknownLang:   "unknown language %q (available: %s)",
	OutOfRange:    "exercises are numbered 1..%d",
	UnknownTrack:  "unknown track %q (available: %s)",

	Intro:     "speclings: learn formal verification by fixing small, broken files, one at a time.",
	NextUp:    "next: %s",
	TrackDone: "all solved",
	HowTo:     "Run speclings <track> to start or continue a track, e.g. speclings %s",

	VerifyWrongFailure: "fails for another reason: %s",
	VerifyNoSnippet:    "snippet not found: %q",
	VerifyCodeDiffers:  "code differs from en: %s",
	VerifyMissing:      "not translated (falls back to en)",
	VerifySolution:     "solution",
	VerifyCoverage:     "%s: %d/%d translated",
	VerifyAllOK:        "All %d exercises are OK.",
	VerifyFailed:       "%d of %d exercises have problems.",
}

var ko = Messages{
	Checking: "검사 중",
	NeedsFix: "고쳐야 합니다: %s",
	Result:   "결과: ",
	Expected: "기대: ",
	Hint:     "힌트: ",
	HintHow:  "%s 로 볼 수 있습니다",
	HintFor:  "%s 힌트:",
	File:     "파일: ",
	Cont:     "        ",

	AllDone:       "모든 문제를 풀었습니다!",
	WatchWaiting:  "저장하면 다시 검사합니다. (Ctrl-C 로 종료)",
	Fallback:      "(아직 번역되지 않아 영어판을 씁니다)",
	ProgressReset: "진도를 지웠습니다. 다음 실행은 001 부터 검사합니다.",
	Restored:      "원래 상태로 되돌렸습니다: %s",
	BackedUp:      "이전 파일: %s",
	Renumbered:    "문제 번호가 바뀌었습니다: %s → %s",
	LangSet:       "언어: %s",
	LangKeep:      "work/ 에 이미 있는 문제는 원래 언어 그대로입니다. 다시 받으려면 -restore N 을 쓰세요.",
	UnknownLang:   "알 수 없는 언어 %q (가능: %s)",
	OutOfRange:    "문제는 1..%d 번까지 있습니다",
	UnknownTrack:  "알 수 없는 트랙 %q (가능: %s)",

	Intro:     "speclings: 작게 고장 난 파일을 하나씩 고치면서 형식 검증을 배웁니다.",
	NextUp:    "다음: %s",
	TrackDone: "모두 풀었습니다",
	HowTo:     "speclings <트랙> 으로 트랙을 시작하거나 이어서 하세요. 예: speclings %s",

	VerifyWrongFailure: "다른 이유로 실패: %s",
	VerifyNoSnippet:    "코드 조각을 찾을 수 없음: %q",
	VerifyCodeDiffers:  "en 과 코드가 다름: %s",
	VerifyMissing:      "번역 없음 (en 으로 대체)",
	VerifySolution:     "정답",
	VerifyCoverage:     "%s: %d/%d 번역됨",
	VerifyAllOK:        "%d 개 문제 모두 정상입니다.",
	VerifyFailed:       "%d/%d 개 문제에 문제가 있습니다.",
}

// BaseLang is the default and reference language. Every exercise is written in it first,
// and the code in every other language must match it.
const BaseLang = "en"

var catalogs = map[string]*Messages{"en": &en, "ko": &ko}

// m holds the messages for the current language; SetLang switches it.
var m = catalogs[BaseLang]

// M returns the engine's messages in the current language, for tracks that report
// what the engine also reports (e.g. VerifyWrongFailure).
func M() *Messages { return m }

// Languages returns the available languages, sorted.
func Languages() []string { return slices.Sorted(maps.Keys(catalogs)) }

func languages() string { return strings.Join(Languages(), ", ") }

// L is a string per language. Missing languages fall back to BaseLang.
type L map[string]string

// In returns l in lang, or in BaseLang if l has no text for lang.
func (l L) In(lang string) string {
	if s := l[lang]; s != "" {
		return s
	}
	return l[BaseLang]
}

var verb = regexp.MustCompile(`%[-+# 0]*[0-9]*(?:\.[0-9]+)?[a-zA-Z%]`)

// CatalogProblems checks a set of message catalogs, one struct of strings per language:
// there must be one per language of Languages(), and every message must be non-empty and
// use the same fmt verbs, in the same order, as BaseLang. Otherwise Sprintf produces
// garbage such as %!d(string=...). Tests call it for the engine's and each track's catalogs.
func CatalogProblems[T any](cats map[string]*T) []string {
	var problems []string
	if got := slices.Sorted(maps.Keys(cats)); !slices.Equal(got, Languages()) {
		problems = append(problems, "languages "+strings.Join(got, ", ")+", want "+languages())
	}
	base, ok := cats[BaseLang]
	if !ok {
		return problems
	}
	b := reflect.ValueOf(*base)
	for _, lang := range slices.Sorted(maps.Keys(cats)) {
		v := reflect.ValueOf(*cats[lang])
		for i := range v.NumField() {
			name := v.Type().Field(i).Name
			got, want := v.Field(i).String(), b.Field(i).String()
			if got == "" {
				problems = append(problems, lang+"."+name+" is empty")
			}
			if g, w := verb.FindAllString(got, -1), verb.FindAllString(want, -1); !slices.Equal(g, w) {
				problems = append(problems, lang+"."+name+" has verbs "+strings.Join(g, " ")+", "+BaseLang+" has "+strings.Join(w, " "))
			}
		}
	}
	return problems
}
