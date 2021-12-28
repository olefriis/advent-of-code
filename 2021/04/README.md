# Day 4

A bit more code is required here. In my initial implementation I had rows and columns as individual
properties of the `Board` class, but it turns out we can just take all the rows and all the columns
and store them in one big list - as long as one of them are fully drawn, the board wins. Thanks to
Ruby's `Array#transpose`, getting a list of the columns is super easy.

For part 2, it took me a while to realize that the puzzle output should be the number that actually
finishes the last board, instead of the number that finishes the next-to-last board (thus deeming
the remaining board the loosing board). Anyway, thanks to the puzzle description I can only blame
myself.
