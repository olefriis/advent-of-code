# Day 15

Part 1 is a typical Dijkstry-style "shortest path" thing, which for some reason took me a very
long time to get right. However, the approach worked instantly for part 2. I've heard of people
doing a recursive method for part 1, and that just won't work for part 2 because it's too slow.

Part 2 was initially pretty slow, since I wasn't using a priority queue - no such thing comes
with Ruby's standard library. But it was still fine enough for getting the right puzzle output.
However, after thinking a bit about it, I came up with the `HalfArsedPriorityQueue` from the
`run_2.rb` file. The idea is that "the edge" in the graph traversal will always have a limited
range in priorities, since the input "risk levels" vary between 1 and 9. So we can use that
information to make something that is really simple to implement and works perfectly for our
use case.
