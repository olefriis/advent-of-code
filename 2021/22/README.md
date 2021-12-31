# Day 22

For part 1, I went with the easy solution of just modelling each individual cube, even though
it was super obvious what would happen in part 2. Anyway, it ran in about 75s, which was good
enough.

That approach won't work for part 2. I considered implementing a "cuboid-splitting" algorithm,
but decided that I wasn't up for it that morning. Instead, I went with a solution very similar
to the one in part 1, but where the 3D space would be split up in the subsections that are
actually used in the puzzle input. This means that the modelled cubes will have different
sizes.

So for each input line specifying a cuboid, e.g.

```
on x=-89813..-14614,y=16069..88491,z=-3297..45228
```

the script will record `-89813` and `-14614 + 1` as relevant points on the x axis, `16069` and
`88491 + 1` on the y axis, and `-3297` and `45228 + 1` on the z axis. The we just map these
coordinates to `0`, `1`, `2`, etc. for each axis, and when calculating the areas that are `on`
at the end, we map the other way to get the actual sizes.

My first implementation used a `Hash` with 3D coordinates. This was super slow - about 30 minutes
I guess. Redoing it with arrays of arrays cut down the time to a bit more than a minute.

However, even though I had my stars, I couldn't leave it there. Others were doing it "properly"
by splitting cuboids, and I wanted to do that too. My first attempt, in `run_2_2.rb`, is a weird
attempt at taking a 1-dimensional list of intervals that are split up and merged in each step,
combined into lists of these (thus resulting in a 2D data structure), and finally "stacking"
these, resulting in a proper 3D structure. It works, and it runs in less than 2 seconds, so it is
a vast improvement on the "array of arrays of arrays" approach.

But the "stack of lists of intervals" approach did turn out to be much more complicated than I
thought initially, so I gave a proper "cuboid-splitting" algorithm a go. The result is in
`run_2_3.rb`, it runs in about 0.2s, and it turned out to be the shortest of my part 2 attempts.
It did take a bit of time to get it right, but I'm glad I did it. (And I'm also happy that I went
with the much simpler approach that morning...)
