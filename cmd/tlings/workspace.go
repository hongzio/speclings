package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
	"time"
)

// workspace is work/, the directory where the learner solves exercises.
// Originals in exercises/ are never touched; each exercise is copied here when reached.
type workspace struct {
	root  string
	state state
}

// state is saved in work/.tlings.
type state struct {
	Lang string `json:"lang"`
	Done string `json:"done,omitempty"` // the last exercise passed
}

func openWorkspace(root string) (*workspace, error) {
	w := &workspace{root: root, state: state{Lang: baseLang}}
	b, err := os.ReadFile(w.statePath())
	switch {
	case errors.Is(err, fs.ErrNotExist):
		return w, nil
	case err != nil:
		return nil, err
	}
	if err := json.Unmarshal(b, &w.state); err != nil {
		return nil, fmt.Errorf("%s: %w", w.statePath(), err)
	}
	if catalogs[w.state.Lang] == nil {
		w.state.Lang = baseLang
	}
	return w, nil
}

func (w *workspace) dir() string       { return filepath.Join(w.root, "work") }
func (w *workspace) statePath() string { return filepath.Join(w.dir(), ".tlings") }

func (w *workspace) save() error {
	if err := os.MkdirAll(w.dir(), 0o755); err != nil {
		return err
	}
	b, _ := json.MarshalIndent(w.state, "", "  ")
	return os.WriteFile(w.statePath(), append(b, '\n'), 0o644)
}

// nextIndex returns the 0-based index of the exercise after the last one passed.
func (w *workspace) nextIndex() int {
	for i, ex := range exercises {
		if ex.Name == w.state.Done {
			return i + 1
		}
	}
	return 0
}

// hasExercises reports whether any exercise has been copied to work/.
func (w *workspace) hasExercises() bool {
	matches, _ := filepath.Glob(filepath.Join(w.dir(), "*.tla"))
	return len(matches) > 0
}

// source returns the path of the original in lang, or of the baseLang one (with fallback set) if there is no translation.
func source(root, lang, file string) (path string, fallback bool) {
	p := filepath.Join(root, "exercises", lang, file)
	if isFile(p) {
		return p, false
	}
	return filepath.Join(root, "exercises", baseLang, file), lang != baseLang
}

// ensure copies ex's files (.tla, .cfg and helper modules) into work/ unless they
// are already there. It returns fallback = true if the .tla fell back to English.
func (w *workspace) ensure(ex Exercise) (fallback bool, err error) {
	if err := os.MkdirAll(w.dir(), 0o755); err != nil {
		return false, err
	}
	for _, f := range ex.files() {
		dst := filepath.Join(w.dir(), f)
		if isFile(dst) {
			continue
		}
		src, fb := source(w.root, w.state.Lang, f)
		if err := copyFile(src, dst); err != nil {
			return false, err
		}
		fallback = fallback || (fb && f == ex.Name+".tla")
	}
	return fallback, nil
}

// restore resets ex to the original, keeping the learner's files as .bak.
func (w *workspace) restore(ex Exercise) (backups []string, err error) {
	for _, f := range ex.files() {
		p := filepath.Join(w.dir(), f)
		if !isFile(p) {
			continue
		}
		if err := os.Rename(p, p+".bak"); err != nil {
			return nil, err
		}
		backups = append(backups, p+".bak")
	}
	_, err = w.ensure(ex)
	return backups, err
}

// copyFile also copies the modification time, so that copying alone does not trigger -watch.
func copyFile(src, dst string) error {
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

// latestMod returns the latest modification time of the .tla and .cfg files in dir.
// It ignores .tlings (progress) and .bak files: saving progress must not trigger another check.
func latestMod(dir string) time.Time {
	var latest time.Time
	entries, _ := os.ReadDir(dir)
	for _, e := range entries {
		if ext := filepath.Ext(e.Name()); ext != ".tla" && ext != ".cfg" || strings.HasPrefix(e.Name(), ".") {
			continue
		}
		if info, err := e.Info(); err == nil && info.ModTime().After(latest) {
			latest = info.ModTime()
		}
	}
	return latest
}
