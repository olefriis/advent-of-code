# Day 10

Fun exercise, but some of the worst Rust code I've written. It would have been nicer if I could do
"downward ranges".

Also, found out you cannot do `.sort_by_key` on a Vec if the key is f64 because f64 (or f32) does not
compare in Rust. Jeez. Had to do a lot of work to make OrderedFloat.

One very curious thing: My part 2 solution does _not_ create the correct output given the test input
(it is about 60 positions off), but worked just fine on the right input. I have no idea what is wrong.

UPDATE: I had a bug in the sorting of the upper left quadrant. And the example input's asteroid number
200 is exactly in the upper left quadrant, so this fixed it. However, for the real input the answer
is still the same, and that is also in the upper left quadrant... Very weird...

Anyhow, the basic algorithm to find the visible asteroids from a given point very much resembles Sieve
of Eratosthenes: Go gradually from the point, then mark multiples of the distance as viewed (and check
whether we bump into an asteroid along the way). On subsequent runs, ignore already viewed positions.
