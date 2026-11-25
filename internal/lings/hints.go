package lings

import (
	"fmt"
	"io"
	"slices"
)

// hints returns the hints of ex, from the vaguest to the fullest: its Nudges, then its Hint.
func hints(ex Exercise) []L { return append(slices.Clone(ex.Nudges), ex.Hint) }

// hintCommand is the command that shows the hint of exercise i of t (0-based), given the
// index of the learner's current exercise.
func hintCommand(t Track, i, current int) string {
	cmd := "speclings " + t.ID() + " -hint"
	if i != current {
		cmd += fmt.Sprintf(" -n %d", i+1)
	}
	return cmd
}

// showHint prints the hints of ex that -hint has shown before, and one more, and records that.
// An exercise with a single hint shows it as it is. cmd is the command, for "run it again".
func (w *workspace) showHint(out io.Writer, t Track, ex Exercise, cmd string) error {
	hs := hints(ex)
	fmt.Fprintf(out, m.HintFor+"\n", ex.Name)
	if len(hs) == 1 {
		fmt.Fprintln(out, ex.Hint.In(w.state.Lang))
		return nil
	}
	n := min(w.hintsSeen(t, ex.Name)+1, len(hs))
	for i, h := range hs[:n] {
		fmt.Fprintf(out, "%s %s\n", Dim(fmt.Sprintf("(%d/%d)", i+1, len(hs))), h.In(w.state.Lang))
	}
	if n < len(hs) {
		fmt.Fprintln(out, Dim(fmt.Sprintf(m.HintMore, cmd)))
	}
	w.setHintsSeen(t, ex.Name, n)
	return w.save()
}

// hintStatus says, for the line under a failed check, how many hints of ex the learner has
// seen, e.g. " (1/3 seen)"; "" for an exercise with a single hint.
func (w *workspace) hintStatus(t Track, ex Exercise) string {
	if len(ex.Nudges) == 0 {
		return ""
	}
	return fmt.Sprintf(m.HintSeen, w.hintsSeen(t, ex.Name), len(ex.Nudges)+1)
}
