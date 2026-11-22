package main

import (
	"os"
	"path/filepath"
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

func TestMissingAssumes(t *testing.T) {
	root := t.TempDir()
	if err := os.MkdirAll(filepath.Join(root, "exercises", baseLang), 0o755); err != nil {
		t.Fatal(err)
	}
	orig := "---- MODULE X ----\n\\* ASSUME in a comment is ignored\nASSUME 7 \\div 2 = ???\nASSUME Sq(5) = 25\n====\n"
	if err := os.WriteFile(filepath.Join(root, "exercises", baseLang, "X.tla"), []byte(orig), 0o644); err != nil {
		t.Fatal(err)
	}
	tests := []struct {
		name, work string
		missing    int
	}{
		{"blank filled", "ASSUME 7 \\div 2 = 3\nASSUME Sq(5) = 25\n", 0},
		{"whitespace and parentheses in the blank", "ASSUME 7 \\div 2=(3)\nASSUME  Sq(5)  =  25\n", 0},
		{"extra PrintT", "ASSUME 7 \\div 2 = 3\nASSUME PrintT(7 \\div 2)\nASSUME Sq(5) = 25\n", 0},
		{"commented out", "ASSUME 7 \\div 2 = 3\nASSUME PrintT(7 \\div 2)\n\\* ASSUME Sq(5) = 25\n", 1},
		{"blank left empty", "ASSUME 7 \\div 2 = \nASSUME Sq(5) = 25\n", 1},
		{"replaced by TRUE", "ASSUME TRUE\nASSUME TRUE\n", 2},
		{"left side changed", "ASSUME 6 \\div 2 = 3\nASSUME Sq(5) = 25\n", 1},
	}
	for _, tt := range tests {
		f := filepath.Join(root, "work.tla")
		if err := os.WriteFile(f, []byte(tt.work), 0o644); err != nil {
			t.Fatal(err)
		}
		if got := missingAssumes(root, Exercise{Name: "X"}, f); len(got) != tt.missing {
			t.Errorf("%s: missing = %q, want %d", tt.name, got, tt.missing)
		}
	}

	// The line with Broken.At only has to keep the At snippet: its value may change.
	at := Exercise{Name: "X", Broken: Broken{At: "ASSUME Sq(5)"}}
	for work, missing := range map[string]int{
		"ASSUME 7 \\div 2 = 3\nASSUME Sq(5) = 26\n":     0,
		"ASSUME 7 \\div 2 = 3\n\\* ASSUME Sq(5) = 26\n": 1,
	} {
		f := filepath.Join(root, "work.tla")
		if err := os.WriteFile(f, []byte(work), 0o644); err != nil {
			t.Fatal(err)
		}
		if got := missingAssumes(root, at, f); len(got) != missing {
			t.Errorf("At %q: missing = %q, want %d", work, got, missing)
		}
	}
}
