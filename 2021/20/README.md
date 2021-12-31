# Day 20

I guess most people got trolled by the puzzle input here. At least it took me a couple of minutes
to understand first of all why my puzzle answer kept turning out to be incorrect, and why changing
the grid size would influence the answer from my script. Then it was just a big :facepalm: and
finding out how to fix that.

The initial implementation would just grab whatever value would be present in `image[0][0]`
whenever the iteration would try to go beyond the bounds of the image, and also making sure that
the image would grow to accommodate 2 extra pixels in each direction for each new iteration. That
worked OK, but it wasn't pretty.

So I've "code-golfed" this one into a pretty elegant solution if you ask me: I frame the original
image with 3 extra pixels in each direction, and then the pixel picking will "wrap around". This
is enough to simulate "infinity" in all directions, and it works beautifully. On each iteration,
the image is expanded 2 pixels in every direction.
