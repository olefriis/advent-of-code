# Day 7

I took the time to "code golf" the solutions here :smile:

For part 1, the most optimal point on the axis turns out to be the median of the crab positions. You
can see that by considering the leftmost and rightmost crabs: For them, it does not matter what the
final position is, as long as it's somewhere between them. Every time you move the final point a bit
to the left, the leftmost crab will have to move a bit less, while the rightmost crab will have to
move the exact same distance more. So in that way you can "peel off" the leftmost and righmost pairs,
until you only have the median crab left.

Though, for my part 1 solution, I don't make any median calculation, as I didn't have that insight
when solving the puzzle. Instead, I just try out every position from the leftmost to the rightmost
crab. That's super simple and runs in 0.2s anyway.

For part 2, the cost of moving a distance of `n`  can be calculated as `n*(n+1)/2`. These are called
triangular numbers, and the formula is very obvious if you try to visualize it:

`n*n` is a whole square. Picture the square with your numbers as bars starting at the left and going
to the right - being `1` tall to the left and `n` tall to the right. This will cover almost exactly
half the square - for example, for `n=5`:

```
    #
   ##
  ###
 ####
#####
```

In fact, each bar will cover a tiny bit more than the diagonal line going from the bottom left to the
upper right of your square. Each bar will cover exactly `1/2` "too much" compared to that line.

Below the diagonal line you will have an area of `1/2 * n*n` - half of your square. Then you just add
`n/2` to compensate for the extra area taken by the bars, since it's `1/2` for each bar. And you end
up with the formula.
