# Day 18

I thought about this for a day before doing my first implementation. Turned out, that was WAY too inefficient.
The idea was to just spawn new "player objects" from existing "player objects" based on the choices available
to each "player object". The big optimization I had was that each player would have a list of positions it has
already been at and shouldn't return to, since that would be just wasting steps. Of course, this list would be
reset every time the player found a key, as then it would be OK to go back.

This worked GREAT for the example mazes, but for the real input I very quickly ended up with far too many
player objects. I tried to cheat by changing the starting area of my input from this:

```
.......
##.@.##
.....#.
```
to this:
```
.......
###@###
.....#.
```

to avoid some walking in circles. Still, it took forever, and after 1576 iterations I had more than one million
player objects.

I also tried to remove dead ends from the map. This just allowed me to go to 1702 iterations before reacing one
million player objects...

So, new strategy...