// speclings is the runner of the speclings tutorials: learn formal verification by
// fixing small, broken files, one track (tool) at a time. See internal/lings for the commands.
package main

import (
	"os"

	"github.com/hongzio/speclings/internal/lings"
	lean "github.com/hongzio/speclings/lean/track"
	tla "github.com/hongzio/speclings/tla/track"
)

func main() {
	// The tracks, in learning order.
	os.Exit(lings.Main(tla.New(), lean.New()))
}
