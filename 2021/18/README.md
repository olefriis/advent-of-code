# Day 18

This puzzle took me a while to understand. Initially I thought that the description "To explode
a pair, the pair's left value is added to the first regular number to the left of the exploding
pair (if any)" only meant I had to consider numbers at the same level as the pair that exploded.
I had a "working" solution when I got to that realization, so I had to do a LOT of work to make
that work.

I started out with a solution that worked on a recursive data structure, which meant that to
"explode" a pair, my implementation would have to "jump up and down" the data structure to find
the neighbour numbers. That was super painful, but it ended up getting the job done. You can
check the file history for the initial, super messy version.

So I had to redo this after having supplied the puzzle answers. It turns out that everything
becomes much simpler if you work on a flat structure: An array that contains `[`, `]`, `,`,
and integers.

I'm especially proud of my `magnitude` function, which iterates on the array and keeps reducing
`[ n1 , n2 ]` into just an integer that's the magnitude of this expression (`3*n1 + 2*n2`). By
just iterating until we have no pairs left, we'll end up with an array with a single element,
which is the magnitude of the whole original "snailfish number".
