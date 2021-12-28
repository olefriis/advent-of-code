# Day 6

There's just one `run.rb` here, which produces the output for part 1. To make it produce the output
for part 2, change `80` to `256` on line 6.

In this one, I found it most obvious to solve part 1 in a way that was immediately applicable to part
2, which I guess was my luck. I've heard from a few people who have modelled the lanternfish as
individual objects, which just doesn't work for part 2.

Also, it turns out that you can implement the life cycle as a matrix multiplication. That way, just
in case you were asked for the evolution after an insane amount of days, you can easily multiply
these matrices to accommodate. However, with the exponential development in population, this would
give gigantic numbers as a result, which would require some thinking about how to represent those...
But anyway, that would be an interesting approach.
