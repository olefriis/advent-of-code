# Day 10

Fun exercise, but some of the worst Rust code I've written. It would have been nicer if I could do
"downward ranges".

Also, found out you cannot do `.sort_by_key` on a Vec if the key is f64 because f64 (or f32) does not
compare in Rust. Jeez. Had to do a lot of work to make OrderedFloat.

One very curious thing: My part 2 solution does _not_ create the correct output given the test input
(it is about 60 positions off), but worked just fine on the right input. I have no idea what is wrong.
