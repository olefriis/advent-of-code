PIPES = File.readlines('10/input').map(&:strip).map(&:chars)

NORTH = [0, -1]
SOUTH = [0, 1]
WEST = [-1, 0]
EAST = [1, 0]

PIPE_DIRECTIONS = {
  '|' => [NORTH, SOUTH], # is a vertical pipe connecting north and south.
  '-' => [ EAST,  WEST], # is a horizontal pipe connecting east and west.
  'L' => [NORTH,  EAST], # is a 90-degree bend connecting north and east.
  'J' => [NORTH,  WEST], # is a 90-degree bend connecting north and west.
  '7' => [SOUTH,  WEST], # is a 90-degree bend connecting south and west.
  'F' => [SOUTH,  EAST], # is a 90-degree bend connecting south and east.
  '.' => []              # is ground; there is no pipe in this tile.
}

def inout_of_pipe(x, y)
  pipe = PIPES[y][x]
  PIPE_DIRECTIONS[pipe].map do |d|
    [x + d[0], y + d[1]]
  end.select do |x, y|
    x >= 0 && x < PIPES[0].length && y >= 0 && y < PIPES.length
  end
end

def create_expanded_map
  result = []
  PIPES.each do |line|
    2.times { result << " " * (line.length * 2) }
  end
  result
end

def plot_between(expanded_map, x1, y1, x2, y2)
  start_x, end_x = [x1, x2].minmax
  start_y, end_y = [y1, y2].minmax

  while start_x != end_x
    expanded_map[start_y][start_x] = 'X'
    start_x += 1
  end
  expanded_map[start_y][start_x] = 'X'

  while start_y != end_y
    expanded_map[start_y][start_x] = 'X'
    start_y += 1
  end
  expanded_map[start_y][start_x] = 'X'
end

def flood_map(expanded_map)
  edge = [[0, 0]].to_set
  while !edge.empty?
    next_edge = Set.new
    edge.each do |x, y|
      expanded_map[y][x] = '*'

      [ [x-1, y], [x, y-1], [x, y+1], [x+1, y] ].select do |x2, y2|
        x2 >= 0 && x2 < expanded_map[0].length && y2 >= 0 && y2 < expanded_map.length && expanded_map[y2][x2] == ' '
      end.each do |x2, y2|
        next_edge << [x2, y2]
      end
    end

    edge = next_edge
  end
end

def shrink_map(expanded_map)
  result = []
  PIPES.each_with_index do |line, y|
    l = []
    line.each_with_index do |pipe, x|
      l << expanded_map[y*2][x*2]
    end
    result << l
  end
  result
end

def count_empty_slots(map)
  map.map {|line| line.count(' ')}.sum
end

def find_loop(start_x, start_y)
  previous_x, previous_y = start_x, start_y
  possible_new_positions = inout_of_pipe(start_x, start_y)

  # Return quickly if our start pipe ends up at incompatible neighbours
  valid_start = possible_new_positions.all? {|x, y| inout_of_pipe(x, y).include?([start_x, start_y])}
  return nil unless valid_start
  
  x, y = possible_new_positions.first
  result = [[x, y]]
  while [x, y] != [start_x, start_y]
    raise "x is out of range" if x < 0 || x >= PIPES[0].length
    raise "y is out of range" if y < 0 || y >= PIPES.length

    possible_new_positions = inout_of_pipe(x, y) - [[previous_x, previous_y]]
    if possible_new_positions.empty?
      puts "Dead end - length #{length}"
      return nil
    elsif possible_new_positions.length > 1
      raise "Too many possible new positions: #{possible_new_positions.inspect}"
    end

    # Now we have to check that we're allowed to enter the new position
    new_position = possible_new_positions.first
    if !inout_of_pipe(new_position[0], new_position[1]).include?([x, y])
      puts "Cannot enter #{new_position.inspect} from #{x},#{y}"
      return nil
    end

    previous_x, previous_y = x, y
    x, y = possible_new_positions.first
    result << [x, y]
  end

  result
end

# Find the starting position
line_with_start_position = PIPES.find {|line| line.include?('S')}
start_y = PIPES.index(line_with_start_position)
start_x = line_with_start_position.index('S')

# Try out all possible values for S
loops = (PIPE_DIRECTIONS.keys - ['.']).map do |start_suggestion|
  PIPES[start_y][start_x] = start_suggestion
  find_loop(start_x, start_y)
end.compact

working_loop = loops.first
puts "Part 2: #{working_loop.length / 2}"

# To find out the enclosed area, we magnify create a magnified map (x2) and
# plot the loop there, so that it's possible to squeeze through two pipes
# (as they are now separated by one empty space).
#
# Then we "flood fill" the map from the outside, shrink the map back to the
# size of the input, and count the number of empty spaces.
expanded_map = create_expanded_map
working_loop.each_cons(2) do |pos1, pos2|
  plot_between(expanded_map, pos1[0]*2, pos1[1]*2, pos2[0]*2, pos2[1]*2)
end
first, last = working_loop.first, working_loop.last
plot_between(expanded_map, last[0]*2, last[1]*2, first[0]*2, first[1]*2)
flood_map(expanded_map)
shrunk_map = shrink_map(expanded_map)
puts "Part 2: #{count_empty_slots(shrunk_map)}"
