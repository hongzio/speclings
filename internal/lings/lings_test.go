package lings

import (
	"context"
	"os"
	"path/filepath"
	"slices"
	"strings"
	"testing"
	"time"
)

func TestCatalogsComplete(t *testing.T) {
	for _, p := range CatalogProblems(catalogs) {
		t.Error(p)
	}
}

func TestCatalogProblems(t *testing.T) {
	type msgs struct{ A, B string }
	bad := map[string]*msgs{
		"en": {A: "%d files", B: "ok"},
		"ko": {A: "파일 %s 개", B: ""},
	}
	got := strings.Join(CatalogProblems(bad), "\n")
	for _, want := range []string{"ko.A has verbs %s", "ko.B is empty"} {
		if !strings.Contains(got, want) {
			t.Errorf("problems %q, want one containing %q", got, want)
		}
	}
	if p := CatalogProblems(map[string]*msgs{"en": {A: "a", B: "b"}}); len(p) != 1 || !strings.Contains(p[0], "languages") {
		t.Errorf("a missing language is not reported: %q", p)
	}
}

func TestHintFallback(t *testing.T) {
	h := L{"en": "hello", "ko": "안녕"}
	if h.In("ko") != "안녕" || h.In("ja") != "hello" || (L{"en": "x"}).In("ko") != "x" {
		t.Error("L.In does not fall back to en")
	}
}

// fakeTrack is a track of plain text files whose comments start with #.
type fakeTrack struct{ exs []Exercise }

func (f *fakeTrack) ID() string                    { return "fake" }
func (f *fakeTrack) Title() L                      { return L{"en": "fake"} }
func (f *fakeTrack) Init(Env)                      {}
func (f *fakeTrack) Exercises() []Exercise         { return f.exs }
func (f *fakeTrack) SetLang(string)                {}
func (f *fakeTrack) Prepare(context.Context) error { return nil }
func (f *fakeTrack) Check(context.Context, Check) (Report, error) {
	return Report{OK: true}, nil
}
func (f *fakeTrack) CodeLines(_, src string) []string {
	var out []string
	for l := range strings.Lines(src) {
		if code, _, _ := strings.Cut(l, "#"); strings.TrimSpace(code) != "" {
			out = append(out, strings.TrimRight(code, " \n"))
		}
	}
	return out
}
func (f *fakeTrack) VerifySetup(context.Context) bool { return true }
func (f *fakeTrack) VerifyOriginal(context.Context, int, string) (string, string) {
	return "✓", ""
}
func (f *fakeTrack) VerifySolution(context.Context, int) (string, string) { return "✓", "" }

// testRepo creates a repository with the fake track: exercise 001 has a main file and a
// helper, both translated to ko; exercise 002 is not translated.
func testRepo(t *testing.T) (string, *fakeTrack) {
	t.Helper()
	root := t.TempDir()
	write := func(rel, s string) {
		p := filepath.Join(root, "fake", "exercises", rel)
		if err := os.MkdirAll(filepath.Dir(p), 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(p, []byte(s), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	write("en/001_a.txt", "# en\nx = 1\n")
	write("en/001_a.cfg", "check x\n")
	write("ko/001_a.txt", "# ko\nx = 1\n")
	write("ko/001_a.cfg", "check x\n")
	write("en/002_b.txt", "y = 2\n")
	tr := &fakeTrack{exs: []Exercise{
		{Name: "001_a", Files: []string{"001_a.txt", "001_a.cfg"}},
		{Name: "002_b", Files: []string{"002_b.txt"}},
	}}
	return root, tr
}

func TestCheckManifest(t *testing.T) {
	root, tr := testRepo(t)
	dir := filepath.Join(root, "fake")
	if err := CheckManifest(dir, tr.exs); err != nil {
		t.Error(err)
	}
	misnumbered := []Exercise{tr.exs[1]}
	if err := CheckManifest(dir, misnumbered); err == nil || !strings.Contains(err.Error(), `must start with "001_"`) {
		t.Errorf("err = %v", err)
	}
	missing := []Exercise{{Name: "001_a", Files: []string{"001_a.txt", "001_x.cfg"}}}
	if err := CheckManifest(dir, missing); err == nil || !strings.Contains(err.Error(), "001_x.cfg") {
		t.Errorf("err = %v", err)
	}
}

func TestWorkspace(t *testing.T) {
	root, tr := testRepo(t)
	w, err := openWorkspace(root)
	if err != nil {
		t.Fatal(err)
	}
	if w.state.Lang != BaseLang || w.nextIndex(tr) != 0 || w.hasExercises([]Track{tr}) {
		t.Fatalf("fresh workspace: %+v", w.state)
	}

	// ensure copies every file in the learner's language; a missing translation falls back to en.
	w.state.Lang = "ko"
	if fb, err := w.ensure(tr, tr.exs[0]); err != nil || fb {
		t.Fatalf("ensure 001: fallback=%v err=%v", fb, err)
	}
	if b, _ := os.ReadFile(filepath.Join(w.dir(tr), "001_a.txt")); !strings.HasPrefix(string(b), "# ko") {
		t.Errorf("001_a.txt = %q, want the ko version", b)
	}
	if fb, err := w.ensure(tr, tr.exs[1]); err != nil || !fb {
		t.Fatalf("ensure 002: fallback=%v err=%v", fb, err)
	}
	if !w.hasExercises([]Track{tr}) {
		t.Error("hasExercises = false after copying")
	}

	// ensure keeps the learner's edits; restore backs them up and copies the original again.
	edited := filepath.Join(w.dir(tr), "001_a.txt")
	if err := os.WriteFile(edited, []byte("x = 2\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	if _, err := w.ensure(tr, tr.exs[0]); err != nil {
		t.Fatal(err)
	}
	if b, _ := os.ReadFile(edited); string(b) != "x = 2\n" {
		t.Errorf("ensure overwrote the learner's file: %q", b)
	}
	backups, err := w.restore(tr, tr.exs[0])
	if err != nil || len(backups) != 2 {
		t.Fatalf("restore: %v %v", backups, err)
	}
	if b, _ := os.ReadFile(edited + ".bak"); string(b) != "x = 2\n" {
		t.Errorf("backup = %q", b)
	}

	// Progress is per track and survives a reopen.
	w.setDone(tr, "001_a")
	if err := w.save(); err != nil {
		t.Fatal(err)
	}
	w2, err := openWorkspace(root)
	if err != nil {
		t.Fatal(err)
	}
	if w2.state.Lang != "ko" || w2.nextIndex(tr) != 1 {
		t.Errorf("reopened: %+v", w2.state)
	}
}

// Only the track's exercise files count as changes: not .bak files, not hidden files (progress).
func TestLatestMod(t *testing.T) {
	_, tr := testRepo(t)
	dir := t.TempDir()
	exts := extensions(tr)
	if !exts[".txt"] || !exts[".cfg"] || len(exts) != 2 {
		t.Fatalf("extensions = %v", exts)
	}
	old := time.Now().Add(-time.Hour)
	for _, f := range []string{"001_a.txt", "001_a.txt.bak", ".hidden.txt", "notes.md"} {
		p := filepath.Join(dir, f)
		if err := os.WriteFile(p, nil, 0o644); err != nil {
			t.Fatal(err)
		}
		if f == "001_a.txt" {
			if err := os.Chtimes(p, old, old); err != nil {
				t.Fatal(err)
			}
		}
	}
	if got := latestMod(dir, exts); !got.Equal(old) {
		t.Errorf("latestMod = %v, want %v", got, old)
	}
}

func TestCodeDiff(t *testing.T) {
	root, tr := testRepo(t)
	ex := filepath.Join(root, "fake", "exercises")
	if d := codeDiff(tr.CodeLines, filepath.Join(ex, "en", "001_a.txt"), filepath.Join(ex, "ko", "001_a.txt")); d != "" {
		t.Errorf("same code, different comments: %s", d)
	}
	if d := codeDiff(tr.CodeLines, filepath.Join(ex, "en", "002_b.txt"), filepath.Join(ex, "ko", "002_b.txt")); d != "" {
		t.Errorf("a missing translation must count as matching: %s", d)
	}
	changed := filepath.Join(t.TempDir(), "001_a.txt")
	if err := os.WriteFile(changed, []byte("# ko\nx = 3\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	if d := codeDiff(tr.CodeLines, filepath.Join(ex, "en", "001_a.txt"), changed); !strings.Contains(d, `"x = 1" ≠ "x = 3"`) {
		t.Errorf("codeDiff = %q", d)
	}
}

func TestVerifyOriginal(t *testing.T) {
	root, tr := testRepo(t)
	for _, tt := range []struct {
		i          int
		lang, mark string
	}{
		{0, "en", "✓"},
		{0, "ko", "✓"},
		{1, "ko", "–"}, // not translated
	} {
		if mark, detail := verifyOriginal(context.Background(), root, tr, tt.i, tt.lang); mark != tt.mark {
			t.Errorf("%d %s: %s %s, want %s", tt.i, tt.lang, mark, detail, tt.mark)
		}
	}
	// A translated helper file whose code differs is reported with its name.
	if err := os.WriteFile(filepath.Join(root, "fake", "exercises", "ko", "001_a.cfg"), []byte("check y\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	if mark, detail := verifyOriginal(context.Background(), root, tr, 0, "ko"); mark != "✗" || !strings.Contains(detail, "001_a.cfg") {
		t.Errorf("changed .cfg: %s %s", mark, detail)
	}
}

func TestLanguages(t *testing.T) {
	if !slices.Contains(Languages(), BaseLang) {
		t.Errorf("Languages() = %v lacks %s", Languages(), BaseLang)
	}
}
