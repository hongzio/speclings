package track

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"slices"
	"strings"
)

// Report is the result of checking one file against an exercise.
type Report struct {
	Compiled        // messages from compiling the file
	Problem  string // why the file does not pass, for the learner; "" if it passes
	Output   string // what main printed (exercises with Expect.Output)
}

func (r Report) ok() bool { return r.Problem == "" }

// checkSource checks src as a solution of ex. The steps, in order:
//
//  1. Lean compiles it with no errors and no sorry (and does not stop early, e.g. on a recursion
//     that never ends in a #guard).
//  2. Every #guard of the en original is still there.
//  3. It uses none of ex.Expect.Forbid.
//  4. With ex.Expect.Reference: the declarations of the original are still there, with the
//     same statements, the given definitions unchanged, and only the standard axioms (checker/).
//     With ex.Expect.Recover, the checker elaborates the original itself (it has errors).
//  5. With ex.Expect.Output: main prints exactly that. If it does not finish normally, the
//     problem includes what it printed.
//
// The error is for problems of the setup (no lean, a broken exercise), not of the learner's file.
func checkSource(ctx context.Context, root string, ex Exercise, src []byte) (Report, error) {
	tmp, err := os.MkdirTemp("", "speclings-lean-")
	if err != nil {
		return Report{}, err
	}
	defer os.RemoveAll(tmp)

	learner := filepath.Join(tmp, "learner")
	if err := writeExercise(learner, src); err != nil {
		return Report{}, err
	}
	c, err := compile(ctx, learner)
	r := Report{Compiled: c}
	switch {
	case err != nil:
		return r, err
	case c.TimedOut:
		r.Problem = fmt.Sprintf(m.ProbTimeout, leanTimeout)
		return r, nil
	case c.Crash == crashRecursion:
		r.Problem = m.ProbDeepRecursion
		return r, nil
	case c.Crash != "":
		r.Problem = fmt.Sprintf(m.ProbCrash, c.Crash)
		return r, nil
	case c.has(kindSorry) && onlySorryErrors(c.Msgs):
		r.Problem = m.ProbSorry
		if c.count(sevError) > 0 {
			r.Problem = m.ProbSorryRun
		}
		return r, nil
	case c.count(sevError) > 0:
		r.Problem = fmt.Sprintf(m.ProbErrors, c.count(sevError))
		return r, nil
	}

	orig, err := readOriginal(root, baseLang, ex)
	if err != nil {
		return r, err
	}
	if missing := missingGuards(orig, string(src)); len(missing) > 0 {
		r.Problem = fmt.Sprintf(m.ProbGuard, strings.Join(missing, "\n"))
		return r, nil
	}
	if used := forbidden(string(src), ex.Expect.Forbid); len(used) > 0 {
		r.Problem = fmt.Sprintf(m.ProbForbid, strings.Join(used, ", "))
		if slices.ContainsFunc(used, func(w string) bool { return strings.HasSuffix(w, "?") }) {
			r.Problem += "\n" + m.ProbSearch // exact? and the like: Lean printed what they found
		}
		return r, nil
	}

	if ex.Expect.Reference {
		ref := filepath.Join(tmp, "ref")
		if err := writeExercise(ref, []byte(referenceSource(orig))); err != nil {
			return r, err
		}
		if !ex.Expect.Recover {
			rc, err := compile(ctx, ref)
			if err != nil {
				return r, err
			}
			if rc.TimedOut || rc.count(sevError) > 0 {
				return r, fmt.Errorf(m.RefBroken, ex.Name, firstProblem(rc.Msgs))
			}
		}
		problems, err := compare(ctx, root, ref, learner, ex.Expect.Recover)
		if err != nil {
			return r, err
		}
		if len(problems) > 0 {
			r.Problem = fmt.Sprintf(m.ProbReference, describeRef(problems))
			return r, nil
		}
	}

	if want := ex.Expect.Output; want != "" {
		out, exit, timedOut, err := runMain(ctx, learner)
		r.Output = out
		switch {
		case err != nil:
			return r, err
		case timedOut:
			r.Problem = fmt.Sprintf(m.ProbRunTimeout, runTimeout)
		case isDeepRecursion(out):
			r.Problem = m.ProbDeepRecursion
		case exit != 0:
			r.Problem = fmt.Sprintf(m.ProbRunFailed, exit)
		case out != want:
			r.Problem = fmt.Sprintf(m.ProbOutput, indent(out), indent(want))
			return r, nil
		}
		// When the program did not finish normally, what it printed (an uncaught
		// exception, say) tells why.
		if r.Problem != "" {
			r.Problem += "\n" + m.Printed + "\n" + indent(out)
		}
	}
	return r, nil
}

// onlySorryErrors reports whether every error in msgs is #guard or #eval refusing to run
// code that still contains sorry. Then the sorry is the problem, not the errors.
func onlySorryErrors(msgs []Message) bool {
	for _, msg := range msgs {
		if msg.Severity == sevError &&
			!strings.Contains(msg.Data, "uses 'sorry'") && !strings.Contains(msg.Data, "the 'sorry' axiom") {
			return false
		}
	}
	return true
}

// describeRef explains the checker's findings, one per line.
func describeRef(problems []RefProblem) string {
	var lines []string
	for _, p := range problems {
		var s string
		switch p.Problem {
		case "missing":
			s = fmt.Sprintf(m.RefMissing, p.Decl)
		case "kind":
			s = fmt.Sprintf(m.RefKind, p.Decl, p.Detail)
		case "statement":
			s = fmt.Sprintf(m.RefStatement, p.Decl)
		case "definition":
			s = fmt.Sprintf(m.RefDefinition, p.Decl)
		case "axioms":
			s = fmt.Sprintf(m.RefAxioms, p.Decl, p.Detail)
		default:
			s = fmt.Sprintf("%s: %s %s", p.Decl, p.Problem, p.Detail)
		}
		lines = append(lines, "- "+s)
	}
	return strings.Join(lines, "\n")
}

// firstProblem describes the first error (or else the first warning) in msgs on one line.
func firstProblem(msgs []Message) string {
	for _, sev := range []string{sevError, sevWarning} {
		for _, msg := range msgs {
			if msg.Severity == sev {
				first, _, _ := strings.Cut(msg.Data, "\n")
				return fmt.Sprintf("%d:%d: %s: %s", msg.Pos.Line, msg.Pos.Column, sev, first)
			}
		}
	}
	return m.NoMessages
}

func indent(s string) string {
	if s == "" {
		return "    " + m.Nothing
	}
	return "    " + strings.ReplaceAll(strings.TrimRight(s, "\n"), "\n", "\n    ")
}
