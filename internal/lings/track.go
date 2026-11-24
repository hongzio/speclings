// Package lings is the engine shared by the speclings tracks: the command line, the
// learner's workspace and progress, the check loop and the -verify report for authors.
// A track (tla/track, lean/track, ...) knows its tool: how to check a file and what
// its output means. The engine knows everything that is the same for every track.
package lings

import "context"

// Track is one tutorial of speclings: a tool or language with its own exercises.
//
// The track's files live in <repository>/<ID>/:
//
//	exercises/en/   the broken originals; en is the reference language
//	exercises/<l>/  translations; only comments differ, the code must match en
//	solutions/      the solutions (en)
//
// Learners work in <repository>/work/<ID>/, where the engine copies each exercise when they reach it.
type Track interface {
	// ID names the track on the command line and is its directory, e.g. "tla".
	ID() string
	// Title describes the track in the overview.
	Title() L
	// Init is called once, before any method other than ID.
	Init(env Env)
	// Exercises lists the exercises in learning order. Each name starts with "%03d_".
	Exercises() []Exercise
	// SetLang switches the track's messages to lang, one of Languages().
	SetLang(lang string)
	// Prepare readies the tools before exercises are checked or verified
	// (e.g. builds a checker). It fails when the tools are missing.
	Prepare(ctx context.Context) error
	// Check checks the learner's copy of an exercise. The error is for problems of the
	// setup (a tool that cannot run), not of the learner's files.
	Check(ctx context.Context, c Check) (Report, error)
	// CodeLines returns the code of a file of the track without comments and blank
	// lines, to compare a translation with en.
	CodeLines(file, src string) []string

	// VerifySetup checks the toolchain for -verify, printing a line per finding.
	VerifySetup(ctx context.Context) bool
	// VerifyOriginal checks that the original of exercise i in lang fails in the intended
	// way. The engine has already checked that it exists and that its code matches en.
	// mark is ✓ or ✗; detail explains a ✗.
	VerifyOriginal(ctx context.Context, i int, lang string) (mark, detail string)
	// VerifySolution checks that the solution of exercise i passes.
	VerifySolution(ctx context.Context, i int) (mark, detail string)
}

// Env tells a track where it is.
type Env struct {
	Root string // the repository
	Dir  string // the track's directory, Root/<ID>
}

// Exercise is what the engine needs to know about an exercise; the track keeps the rest.
type Exercise struct {
	Name string
	Hint L
	// Files are copied to work/<ID>/ together. The first is the one the learner
	// edits and is named in messages; the others go with it (a .cfg, helper modules).
	Files []string
}

// Check asks a track to check exercise Index in Dir (work/<ID>/).
type Check struct {
	Index   int
	Dir     string
	Verbose bool                // -v: show the tool's output even when the check passes
	Rel     func(string) string // shortens a path for display
}

// Report is the result of a Check.
type Report struct {
	OK bool
	// Shown is printed right after the ✓ or ✗: the tool's output, unaltered, with its
	// separators. Learning to read it is part of every tutorial.
	Shown    string
	Problem  string // why the exercise does not pass yet, if !OK
	Expected string // what the exercise expects, if !OK
}
