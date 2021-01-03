# Day 3

I've really come to like `HashSet`. It's basic, but works.

I guess part 2 could be done without returning _both_ a set and a map, but it was an easy solution,
given what I had at the end of part 1.

This day is another very good example of how the performance of `HashSet` and `HashMap` vary greatly
whether you compile with `-O` or not:

```
$ rustc run_2.rs && time ./run_2 
Closest overlap is 14746
./run_2  0.97s user 0.01s system 83% cpu 1.171 total
$ rustc -O run_2.rs && time ./run_2
Closest overlap is 14746
./run_2  0.05s user 0.01s system 58% cpu 0.094 total
```

Yup, going from 1.2 to 0.1 seconds!
