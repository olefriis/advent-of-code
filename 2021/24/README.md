# Day 24

Whew! We almost had to cancel Christmas at our house because of this... I was very close to
giving up and just watching some stream of somebody who solved this, but I'm just too stubborn
to do that.

The idea that I ended up with I got pretty quickly - splitting up the puzzle input into sections
each starting with `inp w` and then using dynamic programming to iterate on successful outcomes.
But for some reason I just didn't make it click until much, much later.

I also considered analyzing the whole input program to find some kind of pattern, but I gave up
on that after a while - it just didn't seem right to me to pursue this path. But I've learned
later that others have indeed done that.

One optimization I'm using is that it turns out that each of the `inp w` sections in the puzzle
input is only using the `z` memory value from the previous sections, since each section starts
with commands like these:

```
inp w
mul x 0
(...nothing using y...)
mul y 0
```

So I only store the output `z` values for each section in the iteration. I don't know how much
that means in practice.

It all works, but I couldn't help but make a version that "compiles" the puzzle instruction set
into Ruby code that is `eval`ed. That's in the `run_jit.rb` script. It's very simple and cuts my
execution time for part 1 from 55s to about 8s and part 2 from from 6 1/2 minutes to 1 minute.
