# Day 21

## Part 1
Fun! It took a little while to "get" the instruction set and how to use it to jump sensibly.

## Part 2
This took quite a bit of writing down on paper and guessing a bit on what was a sensible strategy.
I ended up with going with these conditions for jumping:

* D must be there, otherwise it makes no sense at all to jump (we'll just fall down in a hole).
* There must be a hole in A, B, or C, otherwise we could just run to D instead of jumping there,
  and along the way we could get a better picture of the rest of the path. This can be expressed
  as `(!A || !B || !C)`, but this is the same as `!(A && B && C)` which we'll use below.
* When we've landed on D, we want a little wiggle-room. So we want to either be able to jump again
  and thus reach H (so `H` must be true), we should be able to move forward once and do a jump
  (so `E && I`), _or_ we should be able to move two times (so `E && F`). Which means `H || (E && I) || (E && F)`.

So the complete formula is `!(A && B && C) && D && (H || (E && I) || (E && F))`. We can program this like:

```
OR H J   <- J = H

OR E T
AND I T
OR T J    <- J = J || (E && I)

OR E T
AND F T
OR T J   <- J = J || (E && F)

OR A T
AND A T
AND B T
AND C T
NOT T T  <- T = !(A && B && C)

AND T J  <- J = !(A && B && C) && (H || (E & I) || (E && F))
AND D J  <- J = D && !(A && B && C) && (H || (E & I) || (E && F))
```
