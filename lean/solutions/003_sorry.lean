-- leanlings 003: sorry (solution)

def triple (n : Nat) : Nat := 3 * n

#guard triple 0 == 0
#guard triple 4 == 12

def greet (name : String) : String := s!"Hello, {name}!"

#guard greet "Lean" == "Hello, Lean!"
#guard greet "world" == "Hello, world!"
