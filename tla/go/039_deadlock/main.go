// Command 039_deadlock is a program that the Go runtime stops with
// "fatal error: all goroutines are asleep - deadlock!".
// It accompanies tlings exercise 039.
//
// The first exchange over the unbuffered channels works. Then main waits for b
// while the worker waits for a.
//
//	go run ./tla/go/039_deadlock        main receives from b again before sending on a
//	go run ./tla/go/039_deadlock -fix   main sends on a, then receives from b
package main

import (
	"flag"
	"fmt"
)

func main() {
	fix := flag.Bool("fix", false, "send on a before receiving from b the second time")
	flag.Parse()

	a, b := make(chan int), make(chan int) // unbuffered
	go func() {                            // worker
		<-a    // recvA
		b <- 1 // sendB
		<-a    // recvA
		b <- 2 // sendB
	}()
	a <- 1 // sendA
	<-b    // recvB
	if *fix {
		a <- 2 // sendA
		<-b    // recvB
	} else {
		<-b    // recvB: blocks, the worker is waiting for a
		a <- 2 // sendA: never reached
	}
	fmt.Println("done")
}
