# Day 19

A fiddly one, in which a lot of rotations have to be tested against each other.

My original script would start by taking the first scanner and just using its initial rotation as "the
world rotation", and then go through all other scanners and check all of their rotations to see if any
of them could be translated to create at least 12 matches. If so, I would apply the rotation and translation
to all of its beacons and mark it as a "known scanner". This worked well, and gave me the puzzle answer,
but it took about 20 minutes to run!

Even worse, for part 2 exactly the same calculations would have to be done again, which means I had to
wait another 20 minutes for that answer... Well, I had the answers, so everything was good, but I just
couldn't leave it like that.

An initial optimization is to generate all rotations of the beacons for each scanner, so we at least don't
have to do that when we have to check two scanners.

Instead of keeping the known scanners as individual "beacon clouds" to test the unknown scanners against was
a bit uneffective - there is a lot of overlap between the beacon positions in the known scanners. So one easy
optimization is to maintain a "global map" of all the beacon positions that have been identified. Then
testing the unknown scanners is about twice as fast, since there will be about half as many "known beacon
positions" to test against. That would cut the execution time in about half, but it would still take about 2
minutes to finish.

The last optimization is concerned with how to test that a scanner's beacons would match the main map:
Initially I would go through all "main map" prope positions, and for each of these I would go through each
of the scanner beacon positions (in all rotations). For each of these pairs, I would calculate the translation
necessary to move the scanner beacon position to the "main map" beacon position, go through all the scanner
beacon positions, and see if that translation would be able to move at least 12 scanner beacon positions to
positions matching the "main map".

It turns out that this innermost iteration is not needed. When we have a "main map" position, we can do just
one sweep through the scanner beacon positions and calculate the translation moving the scanner beacon position
to the "main map" position. We'll then maintain a count of how many times we'll end up with a given translation
for this iteration. If a certain translation turns up at least 12 times, we're done.

That cut the execution time down to about 18s, which is good enough for me.

One thing to note is that in order to check all rotations, I list all the possible ways we can negate
individual axes, the possible ways we can order x, y, and z, and then I combine those in all possible ways.
This gives 48 possibilities, which turns out to be twice the number of actual possibilities. So if I had
solved this in a "more proper way" of actually doing the possible rotations, I would have ended up with 24
possible rotations, and everything would have run in half the time, assuming the rotations etc. would still
each be equally fast. Oh well. I actually like my simple approach - I like matrices and all, but feel that
the current approach is cleaner.