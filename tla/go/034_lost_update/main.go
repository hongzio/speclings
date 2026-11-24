// Command 034_lost_update runs two goroutines that increment a shared counter
// without synchronization, and counts the increments that get lost.
// It accompanies tlings exercises 034-036.
//
//	go run ./tla/go/034_lost_update               lost updates, counted
//	go run -race ./tla/go/034_lost_update         the race detector reports the data race
//	go run ./tla/go/034_lost_update -fix mutex    the fix from 035
//	go run ./tla/go/034_lost_update -fix atomic   the fix from 036
package main

import (
	"flag"
	"fmt"
	"os"
	"sync"
	"sync/atomic"
)

const (
	rounds     = 100
	increments = 1000 // per goroutine and round
)

func main() {
	fix := flag.String("fix", "", `"mutex" or "atomic"`)
	flag.Parse()

	var incr func(counter *int64, mu *sync.Mutex)
	switch *fix {
	case "":
		incr = func(counter *int64, _ *sync.Mutex) {
			*counter++ // read, then write: another goroutine can run in between
		}
	case "mutex":
		incr = func(counter *int64, mu *sync.Mutex) {
			mu.Lock()
			*counter++
			mu.Unlock()
		}
	case "atomic":
		incr = func(counter *int64, _ *sync.Mutex) {
			atomic.AddInt64(counter, 1) // read and write in one indivisible step
		}
	default:
		fmt.Fprintln(os.Stderr, `-fix must be "mutex" or "atomic"`)
		os.Exit(2)
	}

	bad := 0
	for range rounds {
		var counter int64
		var mu sync.Mutex
		var wg sync.WaitGroup
		for range 2 {
			wg.Go(func() {
				for range increments {
					incr(&counter, &mu)
				}
			})
		}
		wg.Wait()
		if counter != 2*increments {
			bad++
		}
	}
	fmt.Printf("updates were lost in %d of %d rounds\n", bad, rounds)
}
