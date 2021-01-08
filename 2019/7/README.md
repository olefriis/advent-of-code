# Day 7

Not too elegant of a solution... Feeling kinda weird to copy around the Intcode implementation that is
changing slightly from day to day, but that's probably OK.

I've decided to do these exercises in "basic Rust", so no crates. Otherwise I would definitely use Itertools
to come up with all the different permutations of the phase settings. Anyway, for this problem size it's
probably OK.

Regarding part 2... Hmmm... So, I had to refactor the Intcode runner into its own struct, in order to be able
to preserve state. I think I got away with this relatively well. Then there's the part about iterating over
the permutations of phase settings. I've tried to use iterators as much as possible, but maybe it ended up
not being super readable. Also, the approach got less elegant as I found out (near the very end) that the
phase setting is only going to be input in the first iteration.

Also, for part 2 I probably should have taken the opportunity to clean up the methods of the Intcode struct.
Well, that'll _maybe_ happen next time the Intcode is going to be used...