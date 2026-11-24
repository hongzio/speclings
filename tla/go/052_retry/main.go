// Command 052_retry shows how retries charge a payment twice when the server
// is not idempotent. It accompanies tlings exercise 052.
//
// The network is simulated: each request or response is lost with some
// probability, and the client retries until it gets a response.
//
//	go run ./tla/go/052_retry        the server charges every request it receives
//	go run ./tla/go/052_retry -fix   the server remembers request IDs it has applied
package main

import (
	"flag"
	"fmt"
	"math/rand/v2"
)

const (
	payments = 1000
	lossRate = 0.3 // probability that a request or a response is lost
)

type server struct {
	idempotent bool
	charged    map[int]int  // payment ID -> times charged
	applied    map[int]bool // payment IDs already applied (used with -fix)
}

// handle processes a request and reports whether its response got back.
func (s *server) handle(id int) (responded bool) {
	if rand.Float64() < lossRate { // request lost: the server never sees it
		return false
	}
	if !s.idempotent || !s.applied[id] {
		s.charged[id]++
		s.applied[id] = true
	}
	return rand.Float64() >= lossRate // the response may be lost too
}

func main() {
	fix := flag.Bool("fix", false, "make the server idempotent with request IDs")
	flag.Parse()

	s := &server{idempotent: *fix, charged: map[int]int{}, applied: map[int]bool{}}
	for id := range payments {
		for !s.handle(id) { // no response: retry with the same ID
		}
	}
	twice := 0
	for _, n := range s.charged {
		if n > 1 {
			twice++
		}
	}
	fmt.Printf("%d of %d payments were charged more than once\n", twice, payments)
}
