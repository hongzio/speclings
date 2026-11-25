package lings

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

// workspace is work/, where the learner solves exercises: work/<track>/ for each track.
// Originals in <track>/exercises/ are never touched; each exercise is copied here when reached.
type workspace struct {
	root  string // the repository
	state state
}

// state is saved in work/.speclings.
type state struct {
	Lang string            `json:"lang"`
	Done map[string]string `json:"done,omitempty"` // per track: the last exercise passed
}

func openWorkspace(root string) (*workspace, error) {
	w := &workspace{root: root, state: state{Lang: BaseLang}}
	b, err := os.ReadFile(w.statePath())
	switch {
	case errors.Is(err, fs.ErrNotExist):
	case err != nil:
		return nil, err
	default:
		if err := json.Unmarshal(b, &w.state); err != nil {
			return nil, fmt.Errorf("%s: %w", w.statePath(), err)
		}
	}
	if catalogs[w.state.Lang] == nil {
		w.state.Lang = BaseLang
	}
	if w.state.Done == nil {
		w.state.Done = map[string]string{}
	}
	return w, nil
}

func (w *workspace) base() string              { return filepath.Join(w.root, "work") }
func (w *workspace) dir(t Track) string        { return filepath.Join(w.base(), t.ID()) }
func (w *workspace) statePath() string         { return filepath.Join(w.base(), ".speclings") }
func (w *workspace) trackDir(t Track) string   { return filepath.Join(w.root, t.ID()) }
func (w *workspace) setDone(t Track, n string) { w.state.Done[t.ID()] = n }

func (w *workspace) save() error {
	if err := os.MkdirAll(w.base(), 0o755); err != nil {
		return err
	}
	b, _ := json.MarshalIndent(w.state, "", "  ")
	return os.WriteFile(w.statePath(), append(b, '\n'), 0o644)
}

// nextIndex returns the 0-based index of the exercise of t after the last one passed.
func (w *workspace) nextIndex(t Track) int {
	for i, ex := range t.Exercises() {
		if ex.Name == w.state.Done[t.ID()] {
			return i + 1
		}
	}
	return 0
}

// migrate carries the learner's work over to the current names of the exercises of t that
// were renamed (Exercise.Was): progress saved under a former name moves to the current one,
// and files in work/<track>/ named after a former name are renamed, unless a file with the
// current name is already there. It returns the files it renamed, as [from, to] paths.
func (w *workspace) migrate(t Track) (renamed [][2]string, err error) {
	progress := false
	for _, ex := range t.Exercises() {
		for _, old := range ex.Was {
			if w.state.Done[t.ID()] == old {
				w.setDone(t, ex.Name)
				progress = true
			}
			for _, f := range ex.Files {
				suffix, ok := strings.CutPrefix(f, ex.Name)
				if !ok {
					continue
				}
				from, to := filepath.Join(w.dir(t), old+suffix), filepath.Join(w.dir(t), f)
				if !IsFile(from) || IsFile(to) {
					continue
				}
				if err := os.Rename(from, to); err != nil {
					return renamed, err
				}
				renamed = append(renamed, [2]string{from, to})
			}
		}
	}
	if progress {
		err = w.save()
	}
	return renamed, err
}

// hasExercises reports whether any exercise of any track has been copied to work/.
func (w *workspace) hasExercises(tracks []Track) bool {
	for _, t := range tracks {
		if !latestMod(w.dir(t), extensions(t)).IsZero() {
			return true
		}
	}
	return false
}

// source returns the path of the original of t in lang, or of the BaseLang one (with fallback set) if there is no translation.
func (w *workspace) source(t Track, lang, file string) (path string, fallback bool) {
	p := filepath.Join(w.trackDir(t), "exercises", lang, file)
	if IsFile(p) {
		return p, false
	}
	return filepath.Join(w.trackDir(t), "exercises", BaseLang, file), lang != BaseLang
}

// ensure copies ex's files into work/<track>/ unless they are already there.
// It returns fallback = true if the main file fell back to English.
func (w *workspace) ensure(t Track, ex Exercise) (fallback bool, err error) {
	if err := os.MkdirAll(w.dir(t), 0o755); err != nil {
		return false, err
	}
	for i, f := range ex.Files {
		dst := filepath.Join(w.dir(t), f)
		if IsFile(dst) {
			continue
		}
		src, fb := w.source(t, w.state.Lang, f)
		if err := CopyFile(src, dst); err != nil {
			return false, err
		}
		fallback = fallback || (fb && i == 0)
	}
	return fallback, nil
}

// restore resets ex to the original, keeping the learner's files as .bak.
func (w *workspace) restore(t Track, ex Exercise) (backups []string, err error) {
	for _, f := range ex.Files {
		p := filepath.Join(w.dir(t), f)
		if !IsFile(p) {
			continue
		}
		if err := os.Rename(p, p+".bak"); err != nil {
			return nil, err
		}
		backups = append(backups, p+".bak")
	}
	_, err = w.ensure(t, ex)
	return backups, err
}

// extensions returns the extensions of t's exercise files, e.g. .tla and .cfg.
func extensions(t Track) map[string]bool {
	exts := map[string]bool{}
	for _, ex := range t.Exercises() {
		for _, f := range ex.Files {
			exts[filepath.Ext(f)] = true
		}
	}
	return exts
}

// latestMod returns the latest modification time of the files in dir with one of exts.
// It ignores hidden files and .bak files: saving progress must not trigger another check.
func latestMod(dir string, exts map[string]bool) time.Time {
	var latest time.Time
	entries, _ := os.ReadDir(dir)
	for _, e := range entries {
		if !exts[filepath.Ext(e.Name())] || strings.HasPrefix(e.Name(), ".") {
			continue
		}
		if info, err := e.Info(); err == nil && info.ModTime().After(latest) {
			latest = info.ModTime()
		}
	}
	return latest
}
