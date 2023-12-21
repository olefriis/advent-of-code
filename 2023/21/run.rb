require 'pry'
$grid = File.readlines("21/input").map(&:strip).map(&:chars)

startx = starty = 0
$grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    if char == 'S'
      startx = x
      starty = y
    end
  end
end

$grid[starty][startx] = '.'

NORTH = [-1, 0]
SOUTH = [1, 0]
WEST = [0, -1]
EAST = [0, 1]

$result_cache = {}

def positions_after_steps(steps, start_x, start_y)
  if steps > 300
    steps = steps.even? ? 300 : 301
  end
  key = [steps, start_x, start_y]
  return $result_cache[key] if $result_cache[key]

  edge = [[start_x, start_y]]
  steps.times do
    new_edge = Set.new
    edge.each do |x, y|
      [NORTH, SOUTH, WEST, EAST].each do |dx, dy|
        newx = x + dx
        newy = y + dy
        next if newx < 0 || newy < 0 || newx >= $grid[0].length || newy >= $grid.length
        next if $grid[newy][newx] == '#'
        new_edge << [newx, newy]
      end
    end
    edge = new_edge
  end
  result = edge.length
  $result_cache[key] = result
  puts "After #{steps} steps starting at (#{start_x}, #{start_y}), #{result} positions"
  result
end

edge = [[startx, starty]]
64.times do
  new_edge = Set.new
  edge.each do |x, y|
    [NORTH, SOUTH, WEST, EAST].each do |dx, dy|
      newx = x + dx
      newy = y + dy
      next if newx < 0 || newy < 0 || newx >= $grid[0].length || newy >= $grid.length
      next if $grid[newy][newx] == '#'
      new_edge << [newx, newy]
    end
  end
  edge = new_edge
end
puts "Part 1: #{edge.length}"
puts "Also part 1: #{positions_after_steps(64, startx, starty)}"

def steps_before_repeating(start_x, start_y)
  older_edge = []
  old_edge = []
  edge = [[start_x, start_y]]
  i = 1
  break_next_time = false
  loop do
    new_edge = Set.new
    edge.each do |x, y|
      [NORTH, SOUTH, WEST, EAST].each do |dx, dy|
        newx = x + dx
        newy = y + dy
        next if newx < 0 || newy < 0 || newx >= $grid[0].length || newy >= $grid.length
        next if $grid[newy][newx] == '#'
        new_edge << [newx, newy]
      end
    end
    if old_edge == new_edge
      break
    end
    older_edge = old_edge
    old_edge = edge
    edge = new_edge
    i += 1
  end
  [i, edge.count]
end

#puts "Filling up from start in #{steps_before_repeating(startx, starty)} steps" # 131 steps, 7424 positions
#puts "Filling up from right in #{steps_before_repeating($grid.length - 1, starty)} steps" # 196 steps, 7424 positions
#puts "Filling up from left in #{steps_before_repeating(0, starty)} steps" # 196 steps, 7424 positions
#puts "Filling up from top in #{steps_before_repeating($grid.length / 2, 0)} steps" # 196 steps, 7424 positions
#puts "Filling up from bottom in #{steps_before_repeating($grid.length / 2, $grid.length - 1)} steps" # 196 steps, 7424 positions
#puts "Filling up from left bottom in #{steps_before_repeating(0, $grid.length - 1)} steps" # 261 steps, 7424 positions
#puts "Filling up from left top in #{steps_before_repeating(0, 0)} steps" # 261 steps, 7424 positions
#puts "Filling up from right bottom in #{steps_before_repeating($grid.length - 1, $grid.length - 1)} steps" # 261 steps, 7424 positions
#puts "Filling up from right top in #{steps_before_repeating($grid.length - 1, 0)} steps" # 261 steps, 7424 positions

# It takes 67 steps to get to the next map
#n = 66 + 131
n = 26501365
stable_steps = 300 # The least amount of steps we believe we'll need to make a map stable. In reality this is probably 261 steps...

$grids_used = {}
def record_grid(grid, count=1)
  $grids_used[grid] ||= 0
  $grids_used[grid] += count
  grid
end

positions = record_grid(positions_after_steps(n, startx, starty))
remaining_steps_after_going_out_initially = n - 66 # Need to first pass the 65 steps within this map, then another step to get to the next map
puts "Middle position: #{positions}"

# Left and right
remaining_leftright = remaining_steps_after_going_out_initially
while remaining_leftright >= 0
  positions += record_grid(positions_after_steps(remaining_leftright, $grid.length - 1, starty)) # The one to the left, coming in from the middle right
  positions += record_grid(positions_after_steps(remaining_leftright,                0, starty)) # The one to the left, coming in from the middle right

  remaining_leftright -= $grid.length
end
puts "After going left and right: #{positions}"

# Now we go up!
puts "Going up"
remaining_leftright = remaining_steps_after_going_out_initially
while remaining_leftright >= 0
  # The one in the middle
  positions += record_grid(positions_after_steps(remaining_leftright, startx, $grid.length - 1))

  remaining_steps = remaining_leftright - 66
  if remaining_steps >= 0
    # Why do we need to subtract one here? We're sometimes going too far...
    completely_covered_pairs = [remaining_steps / ($grid.length * 2) - 1, 0].max

    if completely_covered_pairs > 0
      positions += completely_covered_pairs * record_grid(positions_after_steps(stable_steps  , $grid.length - 1, $grid.length - 1), completely_covered_pairs) # Even remaining steps (we're going to the left)
      positions += completely_covered_pairs * record_grid(positions_after_steps(stable_steps+1, $grid.length - 1, $grid.length - 1), completely_covered_pairs) # Odd remaining steps (we're going to the left)
      positions += completely_covered_pairs * record_grid(positions_after_steps(stable_steps  ,                0, $grid.length - 1), completely_covered_pairs) # Even remaining steps (we're going to the right)
      positions += completely_covered_pairs * record_grid(positions_after_steps(stable_steps+1,                0, $grid.length - 1), completely_covered_pairs) # Odd remaining steps (we're going to the right)
    end

    remaining_steps -= completely_covered_pairs * $grid.length * 2
    #raise "Weird remaining steps: #{remaining_steps}" if remaining_steps < 0 || remaining_steps >= $grid.length * 2
    while remaining_steps >= 0
      positions += record_grid(positions_after_steps(remaining_steps, $grid.length - 1, $grid.length - 1)) # The one to the left, coming in from the bottom right
      positions += record_grid(positions_after_steps(remaining_steps, 0, $grid.length - 1)) # The one to the right, coming in from the bottom left
      remaining_steps -= $grid.length
    end
  end

  remaining_leftright -= $grid.length
end
puts "After going up: #{positions}"

# Now we go down!
puts "Going down"
remaining_leftright = remaining_steps_after_going_out_initially
while remaining_leftright >= 0
  # The one in the middle
  positions += record_grid(positions_after_steps(remaining_leftright, startx, 0))

  remaining_steps = remaining_leftright - 66
  if remaining_steps >= 0
    # Why do we need to subtract one here? We're sometimes going too far...
    completely_covered_pairs = [remaining_steps / ($grid.length * 2) - 1, 0].max
    if completely_covered_pairs > 0
      positions += completely_covered_pairs * record_grid(positions_after_steps(stable_steps  , $grid.length - 1, 0), completely_covered_pairs) # Even remaining steps (we're going to the left)
      positions += completely_covered_pairs * record_grid(positions_after_steps(stable_steps+1, $grid.length - 1, 0), completely_covered_pairs) # Odd remaining steps (we're going to the left)
      positions += completely_covered_pairs * record_grid(positions_after_steps(stable_steps  ,                0, 0), completely_covered_pairs) # Even remaining steps (we're going to the right)
      positions += completely_covered_pairs * record_grid(positions_after_steps(stable_steps+1,                0, 0), completely_covered_pairs) # Odd remaining steps (we're going to the right)
    end

    remaining_steps -= completely_covered_pairs * $grid.length * 2
    #raise "Weird remaining steps: #{remaining_steps}" if remaining_steps < 0 || remaining_steps >= $grid.length * 2
    while remaining_steps >= 0
      positions += record_grid(positions_after_steps(remaining_steps, $grid.length - 1, 0)) # The one to the left, coming in from the top right
      positions += record_grid(positions_after_steps(remaining_steps, 0, 0)) # The one to the right, coming in from the top left
      remaining_steps -= $grid.length
    end
  end

  remaining_leftright -= $grid.length
end
puts "After going down: #{positions}"

puts "Part 2: #{positions}"
