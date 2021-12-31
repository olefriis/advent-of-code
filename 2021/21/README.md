# Day 21

Nice warm-up in part 1, and a fun, typical Advent of Code twist for part 2.

The part 2 script runs in less than 2 seconds on my machine, but if we want to optimize it a tiny
bit, then instead of doing

```ruby
    [1, 2, 3].each do |roll1|
      [1, 2, 3].each do |roll2|
        [1, 2, 3].each do |roll3|
          die = roll1 + roll2 + roll3

          # ...

          if p1_points >= 21
            winning_p1 += multiplications
          elsif p2_points >= 21
            winning_p2 += multiplications
          else
            new_configuration = Configuration.new(p1_points, p2_points, p1_position, p2_position)
            new_configurations[new_configuration] += multiplications
          end
        end
      end
    end
```

we could go through a map of `die` results and the number of times this particular result occurs
in each loop, since e.g. the value `4` will happen when the rolls are either `1, 1, 2`, `1, 2, 1`,
or `2, 1, 1`, and other `die` values apart from `3` and `9` occur in more than one configuration.
Anyway, with a run time of less than 2 seconds, it's good enough as it is.
