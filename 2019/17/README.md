# Day 17

Part 1 was unusually simple. However, part 2 is pretty involved. So I kinda cheated.

I _guess_ the right way to do it it analyze the path the robot has to follow and automatically chop it so that
it can be defined as 3 overall functions etc. However, I just manually wrote down the whole path from start to
finish and chopped the path manually. The highlighting feature of Visual Studio Code is pretty nifty in that
regard: Select the first chars of the path, and it will show you which other parts of the path are the same
characters. This makes it pretty easy to find the patterns.

Executing the Intcode program in the end to correctly get the input etc. was a bit of trial-and-error, as it is
completely undefined when it stops and expects an input value. Turns out it also outputs the map twice (once
before moving the robot, another one after moving the robot), which was a surprise for me. Anyway, got it working
somehow.
