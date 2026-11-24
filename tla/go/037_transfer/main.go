// Command 037_transfer runs concurrent bank transfers and counts overdrafts.
// It accompanies tlings exercise 037.
//
// Every method locks the bank's mutex, so there is no data race and the race
// detector stays silent. The bug is that Transfer checks the balance and
// withdraws in two separate critical sections.
//
//	go run -race ./tla/go/037_transfer        overdrafts, and no race report
//	go run -race ./tla/go/037_transfer -fix   check and withdraw under one lock
package main

import (
	"errors"
	"flag"
	"fmt"
	"runtime"
	"sync"
)

const rounds = 1000

var ErrInsufficientFunds = errors.New("insufficient funds")

type Bank struct {
	mu       sync.Mutex
	balances map[string]int
}

func (b *Bank) Balance(acct string) int {
	b.mu.Lock()
	defer b.mu.Unlock()
	return b.balances[acct]
}

func (b *Bank) withdraw(acct string, amt int) {
	b.mu.Lock()
	defer b.mu.Unlock()
	b.balances[acct] -= amt
}

func (b *Bank) deposit(acct string, amt int) {
	b.mu.Lock()
	defer b.mu.Unlock()
	b.balances[acct] += amt
}

// Transfer is the buggy version: check, withdraw and deposit are three steps.
func (b *Bank) Transfer(from, to string, amt int) error {
	if b.Balance(from) < amt { // check
		return ErrInsufficientFunds
	}
	// Gosched lets the other goroutine run here more often, so the bug shows up
	// in a few hundred rounds. It widens the window; it does not create it.
	runtime.Gosched()
	b.withdraw(from, amt) // withdraw
	b.deposit(to, amt)    // deposit
	return nil
}

// TransferFixed checks and withdraws in one critical section.
func (b *Bank) TransferFixed(from, to string, amt int) error {
	b.mu.Lock()
	if b.balances[from] < amt {
		b.mu.Unlock()
		return ErrInsufficientFunds
	}
	runtime.Gosched()
	b.balances[from] -= amt
	b.mu.Unlock()
	b.deposit(to, amt)
	return nil
}

func main() {
	fix := flag.Bool("fix", false, "use TransferFixed")
	flag.Parse()

	overdrafts := 0
	for range rounds {
		b := &Bank{balances: map[string]int{"alice": 10, "bob": 0}}
		transfer := b.Transfer
		if *fix {
			transfer = b.TransferFixed
		}
		var wg sync.WaitGroup
		for range 2 {
			wg.Go(func() { _ = transfer("alice", "bob", 10) })
		}
		wg.Wait()
		if b.Balance("alice") < 0 {
			overdrafts++
		}
	}
	fmt.Printf("alice was overdrawn in %d of %d rounds\n", overdrafts, rounds)
}
