lines = File.readlines("14/input").map(&:strip).map(&:chars)

# Wrap a border of #s around the map
lines = lines.map { |line| ['#'] + line + ['#'] }
lines = [['#'] * lines[0].length] + lines + [['#'] * lines[0].length]

NORTH = [0, -1]
SOUTH = [0, 1]
WEST = [-1, 0]
EAST = [1, 0]

def within_bounds(lines, x, y)
  x >= 0 && y >= 0 && x < lines[0].length && y < lines.length
end

def move(lines, direction)
  lines.each_with_index do |line, y|
    line.each_with_index do |char, x|
      if char == '#'
        # Go on a straight line opposite the direction we want to move rocks. Stop at
        # the next #, move all rocks next to the current #.

        # Start by removing all rocks in the way, counting them as we go along
        rocks_to_move = 0
        x1, y1 = x - direction[0], y - direction[1]
        while within_bounds(lines, x1, y1) && lines[y1][x1] != '#'
          if lines[y1][x1] == 'O'
            rocks_to_move += 1
            lines[y1][x1] = '.'
          end
          x1, y1 = x1 - direction[0], y1 - direction[1]
        end

        # Then put them back right next to the # rock
        x1, y1 = x - direction[0], y - direction[1]
        rocks_to_move.times do
          lines[y1][x1] = 'O'
          x1, y1 = x1 - direction[0], y1 - direction[1]
        end
      end
    end
  end
end

def load(lines)
  result = 0
  lines.each_with_index do |line, y|
    rocks = line.count('O')
    # -1 because of the surrounding border we've added
    multiplier = lines.length - y - 1
    result += rocks * multiplier
  end
  result
end

def move_all(lines)
  move(lines, NORTH)
  move(lines, WEST)
  move(lines, SOUTH)
  move(lines, EAST)
end

lines_part_1 = lines.dup
move(lines_part_1, NORTH)
puts "Part 1: #{load(lines_part_1)}"

# Find the start and length of the cycle
cache = {}
total_iterations = 1000000000
i, cycle_start = 0
loop do
  move_all(lines)
  i += 1
  key = lines.map(&:join).join
  cycle_start = cache[key]
  break if cycle_start

  cache[key] = i
end

# Jump as many cycles as possible without going over the total number of iterations,
# then do the remaining iterations.
cycle_end = i
cycle_length = cycle_end - cycle_start
cycles_to_add = (total_iterations - cycle_start) / cycle_length
i = cycle_start + cycles_to_add * cycle_length
(total_iterations - i).times { move_all(lines) }

puts "Part 2: #{load(lines)}"
