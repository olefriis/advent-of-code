# Day 10 - Hoof It

This directory contains both Ruby and C implementations of the solution.

## Ruby Version

Run with:
```bash
ruby run.rb
```

## C Version

### Building

To compile the C version:
```bash
make
```

Or manually:
```bash
gcc -Wall -Wextra -O2 -std=c99 -o run run.c
```

### Running

Run with default input file (10/input):
```bash
./run
```

Run with a custom input file:
```bash
./run sample_input
```

### Testing

Run tests with the sample input:
```bash
make test
```

### Cleaning

Remove compiled binary:
```bash
make clean
```

## Algorithm

The solution solves a topographic map problem where:
- Part 1: Count the number of reachable height-9 positions from each height-0 position (using BFS)
- Part 2: Count all distinct hiking trails from height-0 to height-9 positions (using recursive DFS)

The C version is functionally equivalent to the Ruby version but offers better performance for large inputs.
