package lings

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func IsDir(p string) bool  { fi, err := os.Stat(p); return err == nil && fi.IsDir() }
func IsFile(p string) bool { fi, err := os.Stat(p); return err == nil && fi.Mode().IsRegular() }

// CopyFile also copies the modification time, so that copying alone does not trigger -watch.
func CopyFile(src, dst string) error {
	b, err := os.ReadFile(src)
	if err != nil {
		return err
	}
	info, err := os.Stat(src)
	if err != nil {
		return err
	}
	if err := os.WriteFile(dst, b, 0o644); err != nil {
		return err
	}
	return os.Chtimes(dst, info.ModTime(), info.ModTime())
}

// CheckManifest checks that the exercises of the track in dir are numbered in order
// and that their files exist in dir/exercises/en.
func CheckManifest(dir string, exs []Exercise) error {
	for i, ex := range exs {
		if prefix := fmt.Sprintf("%03d_", i+1); !strings.HasPrefix(ex.Name, prefix) {
			return fmt.Errorf("%s: exercise #%d is named %q; it must start with %q", filepath.Base(dir), i+1, ex.Name, prefix)
		}
		if len(ex.Files) == 0 {
			return fmt.Errorf("%s: exercise %s has no files", filepath.Base(dir), ex.Name)
		}
		for _, f := range ex.Files {
			if p := filepath.Join(dir, "exercises", BaseLang, f); !IsFile(p) {
				return fmt.Errorf("missing %s", p)
			}
		}
	}
	return nil
}

// codeDiff describes the first difference between the code of two files, or returns "" if they match.
// A missing translated file (e.g. an untranslated .cfg) counts as matching, since the English one is used.
func codeDiff(code func(file, src string) []string, base, translated string) string {
	b, err := os.ReadFile(base)
	if err != nil {
		return err.Error()
	}
	t, err := os.ReadFile(translated)
	if err != nil {
		return ""
	}
	name := filepath.Base(base)
	bc, tc := code(name, string(b)), code(name, string(t))
	for i := range max(len(bc), len(tc)) {
		var x, y string
		if i < len(bc) {
			x = bc[i]
		}
		if i < len(tc) {
			y = tc[i]
		}
		if x != y {
			return fmt.Sprintf("%q ≠ %q", x, y)
		}
	}
	return ""
}

var color = func() bool {
	fi, err := os.Stdout.Stat()
	return err == nil && fi.Mode()&os.ModeCharDevice != 0 && os.Getenv("NO_COLOR") == ""
}()

func paint(code, s string) string {
	if !color {
		return s
	}
	return "\x1b[" + code + "m" + s + "\x1b[0m"
}

func Green(s string) string  { return paint("32", s) }
func Red(s string) string    { return paint("31", s) }
func Yellow(s string) string { return paint("33", s) }
func Dim(s string) string    { return paint("2", s) }

// Sep is the line printed below a tool's output.
func Sep() string { return Dim(strings.Repeat("─", 72)) }
