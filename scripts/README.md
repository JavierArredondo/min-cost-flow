# Read file
Use regular expression to get `nodes` and `arcs`. After that create artificial `arcs` for supplies and sinks, theses arcs have `capacity = entry flow`,  `low_capacity = entry flow` and `cost = 0`.

# Algorithms to try to solve the problem

## Very stochastic that doesn't ensure the solution

```bash
in_node = start_node # Initial step is stay in source
while input_flow != output_flow: # Elemental condition of the problem
	to_node = random_neighbour(in_node) # Ask for one neighbour available
	open_pipe(in_node, to_node) # Open the arc flow, occupying the max capacity
	in_node = random_open_node() # Get a new current node, already opened
```

May be this algorithm enter to infinite loop, but with a `break` statement this should be works. For example:
```bash
in_node = start_node 
while input_flow != output_flow:
	to_node = random_neighbour(in_node)
	if to_node not exists: # Oh my god, I haven't neighbours to visit :(
		break
	open_pipe(in_node, to_node) 
	in_node = random_open_node() 
```
