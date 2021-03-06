# Day 18

## Part 1

I thought about this for a day before doing my first implementation. Turned out, that was WAY too inefficient.
The idea was to just spawn new "player objects" from existing "player objects" based on the choices available
to each "player object". The big optimization I had was that each player would have a list of positions it has
already been at and shouldn't return to, since that would be just wasting steps. Of course, this list would be
reset every time the player found a key, as then it would be OK to go back.

This worked GREAT for the example mazes, but for the real input I very quickly ended up with far too many
player objects. I tried to cheat by changing the starting area of my input from this:

```
.......
##.@.##
.....#.
```
to this:
```
.......
###@###
.....#.
```

to avoid some walking in circles. Still, it took forever, and after 1576 iterations I had more than one million
player objects.

I also tried to remove dead ends from the map. This just allowed me to go to 1702 iterations before reacing one
million player objects...

So, new strategy...

Whoa, got it working, but not sure this was the simplest way to do it... For each key, I have a map with a map
from a key set to the minimum number of moves to get to that key with the keys from the key set. Then I just iterate
and go from each of these configurations to all other reachable keys and update the best efforts so far. And quit
when we no more optimize this.

It was HORRIBLE to write this in Rust, as I need to modify the structure I am iterating. And it takes almost 20
seconds to run, which also means there must be a simpler way to do it.

The actual output is not too nice. You need to manually find the line with the fewest moves. Sorry.

UPDATE: I realized that as we iterate through player states, it's much easier to comprehend that each player state
will gain exactly one key in each iteration. Thus, it doesn't make sense to keep the old states in subsequent
iterations - if some state cannot find more keys, it should "die". This simplified the code a bit and made it
_almost_ 10 times faster (2.3 seconds compared to about 20 seconds before).

I think I am ready for part 2. Part 2 _seems_ pretty straightforward to me - instead of each player state having
one position, it will have 4, and on each iteration we will try moving each of these 4 positions. We'll see how
it turns out.

## Part 2

Yup! Basically changed the base data structure to go from superpositions instead of keys, got rid of all the Rust
compiler errors, and it worked first time. Nice.
