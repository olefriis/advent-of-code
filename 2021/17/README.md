# Day 17

This is an interesting one. For getting the puzzle answers quickly, I think I just tested all initial x
and y velocities between -1000 and 1000, or something like that. Then if the trajectory ended up in the
target range, it was good, and when the y value would go below `min_y` from target range or the x value
would go above `max_x` (or not reach `min_x` before the x velocity would drop to `0`), I could rule out
that particular combination. That worked, and the input range was small enough to finish in reasonable
time.

But it was highly unsatisfactory to just try out a pretty random range.

Thinking a tiny bit about it, it is clear that you can easily rule out a lot of potential initial x
velocities: No matter the y velocity, the x velocity must be set so that it ends up in the target x
range before (or when!) it reaches velocity 0 in the x direction.

But the same can be done with the y values. Shooting downwards (negative initial y velocity) is easy to
reason about: It only makes sense to test values between `0` and `min_y`. If you start to fire at velocity
`min_y-1`, the probe will instantly miss the target y range and continue downward.

Reasoning about positive initial y velocities seems much harder, but it turns out that what goes up, must
come down, and when you shoot the probe upwards with initial velocity `vel_y`, then when it hits `y=0`
again, the velocity is `-(vel_y+1)`. So it only makes sense to try initial vertical y velocities between
`-min_y` and `min_y`.

This way, you can independently find relevant initial x and y velocities and try out all combinations of
those. For my puzzle input, that would limit the number of relevant x velocities to 77 and relevant y
velocities to 194, giving a total of 14939 combinations to try out. That's a bit better than the initial
`1000*2000` combinations I did. Not that it makes a lot of difference performance-wise, but it is nice
to know that there isn't any magic combination outside of that range that we would have missed by not
understanding the puzzle properly.
