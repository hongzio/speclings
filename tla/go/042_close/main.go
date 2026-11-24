// Command 042_close shows a channel closed too early: a producer then panics
// with "send on closed channel". It accompanies tlings exercise 042.
//
// A real program would crash on the first panic. This one recovers it in the
// producer, so that it can count how often it happens.
//
//	go run ./tla/go/042_close        close without waiting for the producers
//	go run ./tla/go/042_close -fix   close after wg.Wait()
package main

import (
	"flag"
	"fmt"
	"sync"
	"sync/atomic"
)

const rounds = 1000

func main() {
	fix := flag.Bool("fix", false, "close the channel after all producers are done")
	flag.Parse()

	var panicked atomic.Int32
	for range rounds {
		jobs := make(chan string, 1)
		var wg sync.WaitGroup
		for _, p := range []string{"p1", "p2"} {
			wg.Go(func() {
				defer func() {
					if recover() != nil { // send on closed channel
						panicked.Add(1)
					}
				}()
				jobs <- p // send
			})
		}
		go func() {
			if *fix {
				wg.Wait()
			}
			close(jobs) // close
		}()
		for range jobs { // recv, until closed and empty
		}
		wg.Wait()
	}
	fmt.Printf("a producer sent on a closed channel %d times in %d rounds\n", panicked.Load(), rounds)
}
