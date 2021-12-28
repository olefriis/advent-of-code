# Day 7

I took the time to "code golf" the solutions here :smile:

Though, it seems like I'm missing something here. At least for part 1, there's probably some simple
formula for calculating the optimal position to move the crabs to. I don't make any attempt at that,
but just try out every position from the leftmost to the rightmost crab. That's super simple and runs
in 0.2s anyway.

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

In fact, each bar will cover a tiny bit more than the line going from the bottom left to the upper right of your square.
Each bar will cover exactly `1/2` "too much" compared to that line.

Below the line you will have an area of `n*n/2` - half of your square. Then you just add `n/2` to compensate for the extra
area taken by the bars, since it's `1/2` for each bar. And you end up with the formula.
