# Day 23

After day 22, I really needed something easy. And I got it!

Except... I'm doing this in Rust. First time doing mutable shared references. I decided to
try to keep my Intcode implementation relatively general, so I wanted to extract the
iterator that provides it input. This was harder than expected.
