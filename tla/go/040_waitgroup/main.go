// Command 040_waitgroup shows why wg.Add must be called before the goroutine
// starts, not inside it. It accompanies exercise 040 of the tla track.
//
//	go run ./tla/go/040_waitgroup        Wait sometimes returns before the work is done
//	go run ./tla/go/040_waitgroup -fix   main calls wg.Add before starting the goroutines
package main

import (
	"flag"
	"fmt"
	"sync"
	"sync/atomic"
)

const (
	rounds  = 1000
	workers = 2
)

// add calls wg.Add. go vet reports wg.Add written directly inside a goroutine,
// so the buggy version below calls it through this helper to compile cleanly.
// The bug is the same.
func add(wg *sync.WaitGroup) { wg.Add(1) }

func main() {
	fix := flag.Bool("fix", false, "call wg.Add in main, before starting the goroutines")
	flag.Parse()

	early := 0
	for range rounds {
		var wg sync.WaitGroup
		var finished atomic.Int32
		if *fix {
			wg.Add(workers) // add
		}
		for range workers { // spawn
			go func() {
				if !*fix {
					add(&wg) // add: too late, main may already be in Wait
				}
				defer wg.Done()
				finished.Add(1) // work
			}()
		}
		wg.Wait() // wait
		if finished.Load() != workers {
			early++
		}
	}
	fmt.Printf("Wait returned before all work was done in %d of %d rounds\n", early, rounds)
}
