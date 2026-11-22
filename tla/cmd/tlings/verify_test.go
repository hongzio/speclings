package main

import (
	"slices"
	"testing"
)

func TestCodeLines(t *testing.T) {
	src := `---- MODULE M ----
EXTENDS Naturals   \* trailing comment
\* whole-line comment
(* block
   (* nested *) still comment
*)
S == "a \* not a comment" \* but this is
Init ==
    /\ x = (* inline *) 1
    /\ y = 2
====
`
	want := []string{
		"---- MODULE M ----",
		"EXTENDS Naturals",
		`S == "a \* not a comment"`,
		"Init ==",
		"    /\\ x =  1",
		"    /\\ y = 2",
		"====",
	}
	if got := codeLines(src); !slices.Equal(got, want) {
		t.Errorf("codeLines =\n%q\nwant\n%q", got, want)
	}
}

func TestCodeLinesIgnoresCommentLanguage(t *testing.T) {
	en := "---- MODULE M ----\n\\* The module name\n\\* must match.\nTwo == 1 + 1\n====\n"
	ko := "---- MODULE M ----\n\\* 모듈 이름은 파일 이름과 같아야 합니다.\nTwo == 1 + 1\n====\n"
	if !slices.Equal(codeLines(en), codeLines(ko)) {
		t.Errorf("same code, different comments: %q vs %q", codeLines(en), codeLines(ko))
	}
	changed := "---- MODULE M ----\nTwo == 1 + 2\n====\n"
	if slices.Equal(codeLines(en), codeLines(changed)) {
		t.Error("different code reported as equal")
	}
}
