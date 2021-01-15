# Day 14

Nice exercise!

Part 1, I mostly struggled with Rust. Working with stuff owned by e.g. a HashSet is tedious. I maybe shouldn't be afraid
of using `.clone()` more often...

Ugh! Part 2 took me an hour or so to ponder about. Then I realized how easy it is, and quickly changed part 1 to fit
part 2. However, my answer was wrong, even though my solutions were right for the example input! Turned out there was
a rounding error somewhere (either in my code or the official code), so my answer was 1 too high. I haven't dug into
what is wrong, but judging from the output there are a few _very_ minor rounding errors, and together they probably
make my solution give a slightly wrong answer.

Rust notes:
* I wish I could just give a predicate to HashSet, and HashSet would remove the matching elements and return them! Maybe
  this is already possible, but I couldn't find the method.