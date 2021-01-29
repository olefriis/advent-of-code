# Day 22

## Part 1
Part 1 was straightforward.

As expected, part 2 is going to completely change the approach...

## Part 2
This took me a few evenings to get. Definitely the hardest challenge in 2019 so far, and far harder
than anything from 2020 if you ask me.

The point is that we can move around the three techniques so that they do not interleave. Then we can
join the lines with the same techniques and end up with (at most) one line of each technique. I'll
outline below how this happens.

Afterwards, we will add the resulting list to itself a number of times and do the same reduction
again in order to end up with a three-line list of techniques that correspond to repeating our
puzzle input the huge number of times.

And finally we need to "move backwards" through those resulting 3 lines.

And by the way, we will switch to using `u128` and doing modulo operations all the time to avoid
overflows.

### Moving a 'cut' below a 'deal into new stack'
'deal into new stack' just corresponds to reversing the deck, so we can just negate the number in the
'cut' when moving it through a 'deal into new stack'.

Which means that
```
cut X
deal into new stack
```
is the same as
```
deal into new stack
cut -X
```

### Moving a 'cut' below a 'deal with increment'
The 'deal with increment X' will take the old position 0 element and put it at new position 0*X, take
the old position 1 element and put it at 1*X, etc. If we move the deck one to the left (i.e., cut 1),
it will instead take the old position 1 element and put it at 0*X, the old position 2 element and put it
at position 1*X, etc. So each 'cut 1' before a 'deal with increment X' corresponds to instead doing a
'cut X' after the 'deal with increment X'.

So
```
cut X
deal with increment Y
```
is the same as
```
deal with increment Y
cut X*Y mod deck_size
```

### Moving a 'deal with increment' above a 'deal into new stack'
This is tougher. So we have this:
```
deal into new stack
deal with increment X
```
'deal with increment X' will always leave the card at position 0. So in the above, position 0
will end up with the element that was _last_ before doing 'deal into new stack'. So if we switch
the two lines, we will need to do extra work: Add a 'cut' that moves the original last element
back into position 0.

Skipping the part where we take the original last element, find its position, and then reverse
it, we'll get:
```
deal with increment X
deal into new stack
cut deck_size - 1 - ((deck_size - 1) * X) mod deck_size
```
Sure, this creates a new `cut` line, but this is not a problem, since we can just move that to
the bottom of the list of commands by following the rules above.

### Reducing multiple 'deal into new stack'
This is the simplest concept of them all! Each of them just reverses the deck, so just remove
any consecutive pairs of these.

### Reducing multiple 'cut'
This is easy!
```
cut X
cut Y
```
is the same as
```
cut X+Y mod deck_size
```

### Reducing multiple 'deal with increment'
This is not quite as straightforward to realize. However, for 'deal with increment X', we
take each position P and put it in position `P*X mod deck_size`. If we afterwards do a
'deal with increment Y', we put it in position `((P*X) mod deck_size) * Y mod deck_size`,
which again is equal to `P*X*Y mod deck_size` because both X and Y are co-primes with
`deck_size` (because `deck_size` is a prime).

So:
```
deal with increment X
deal with increment Y
```
is the same as
```
deal with increment X*Y mod deck_size
```

### Applying the resulting list a huge number of times
At the end, when we have to shuffle the deck an incredibly huge amount of times, can simply take
the incredibly huge number and break it down as a binary number, meanwhile keeping track of a list
of (at most) three shuffle lines which we will double _and_ reduce each time we halve the incredibly
huge number. This is probably a super bad explanation, so take a look at the code instead :simple_smile:

That result will be (at most) three lines:

```
deal with increment X
deal into new stack
cut Z
```

### Going backwards from position 2020

Going backwards from position 2020 can be done like this:

* Move it `Z` "to the right", getting `P1 = (2020 + Z) mod deck_size`,
* reversing its position if we have the 'deal into new stack' line, getting `P2 = deck_size - P1`
* and... well, do the 'deal with increment X' backwards, getting some value `P3`. This is the original position,
  and thus the card value.

The last part is not exactly obvious how to do. If we do the `deal with increment X` forwards, starting with an
initial deck of cardswith increasing numbers, then the new deck will start with 0 at position 0. At position 1 is
the number we need to do a `deal with increment` with in order to reverse the `deal with increment X` operation.

If you think of it, the `deal with increment X` takes each card at position `P` and puts it on position
`P * X mod deck_size`.

Let's say the card at position 1 has value Y. To "put it back" at its original position, we do `deal with increment Y`,
because then the card will be put back on position Y where it came from. (I'll skip the math because I'm lazy,
and frankly because I just blindly believe that this is always true...)

`deal with increment X` will split up the result into "chunks" of size X. You can see that from the description of
the `deal with increment` technique. So if X is fairly small, we can do some arithmetics to fill out only the
first "chunk", and sooner or later we'll find the value to insert at position 1.

However! The X in `deal with increment X` is probably going to be very large. It was for my puzzle input, at
least. So for this, I split up X into its primes and did the operation on each prime, getting the "reverse
increment" for each and, well, doing the `deal with increment` on each of those. This is fine, given our
description above on how we can combine individual `deal with increment X`es.

## But wait! There's more!
While brushing my teeth one evening, it dawned on me that the above can in fact be simplified quite a bit by
seeing that 'deal into new stack' can be expressed as a 'deal with increment'... This takes away a lot of
the above complexity, and would have saved me a lot of time figuring out how to swap 'deal into new stack'
and 'deal with increment' lines.

Very simply,

```
deal into new stack
```

is the same as

```
deal with increment deck_size - 1
```

Maybe one day I will get back to this exercise and simplify this. But on the other hand, I am also a little
proud that I made the other thing work. It was a BIG DEAL (heh).

UPDATE: Well, I added [run_3.rs](run_3.rs) which does exactly that. But interestingly, it ends up with a
`deal with increment 53487514281045`, and 53487514281045's prime factors are 3, 5, 13, and 274294945031.
Needless to say, 274294945031 is a bit too big for the methodology above, so, well, it just won't work.
Interesting! So I'm not so sorry I spent time on dealing with 'deal into new stack' after all.

UPDATE 2: Now I started looking at other approaches to this whole challenge. Looking at the [super
impressive implementation from sophiebits](https://github.com/sophiebits/adventofcode/blob/main/2019/day22.py),
it's clear that I should have _started_ by reversing the original list and _then_ done the reduction,
as we would then not have to find primes etc. Oh well.
