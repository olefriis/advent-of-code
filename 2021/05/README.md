# Day 5

This is one of those days where you can guess what part 2 is about while doing part 1, and then
you can choose to optimize for that or not. Which I didn't. In fact, I think my part 2 is cleaner
than part 1.

I struggled a lot with part 2 in calculating the `inc_x` and `inc_y` variables. For some reason,
I did not at all consider that any of them could be `0` - I only considered the values `-1` and
`1`. So that took a bit of debugging time.

The `sign` function in part 2 is pretty verbose and can be cleaned up a lot... Also, the `loop`
construct is not super nice, but it works.
