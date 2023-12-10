pipes = File.readlines('10/input').map(&:strip).map(&:chars)

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

start_x, start_y = 0
# Find starting position
pipes.each_with_index do |line, idx|
  start_y = idx
  start_x = line.index('S')
  break if start_x
end

def inout_of_pipe(pipes, x, y)
  pipe = pipes[y][x]
  PIPE_DIRECTIONS[pipe].map do |d|
    [x + d[0], y + d[1]]
  end.select do |x, y|
    x >= 0 && x < pipes[0].length && y >= 0 && y < pipes.length
  end
end

def plot_between(expanded_map, x1, y1, x2, y2)
  start_x, end_x = [x1*2, x2*2].minmax
  start_y, end_y = [y1*2, y2*2].minmax

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
  next_floods = Set.new
  next_floods << [0, 0]
  while !next_floods.empty?
    next_next_floods = Set.new
    next_floods.each do |x, y|
      expanded_map[y][x] = '*'

      [ [x-1, y], [x, y-1], [x, y+1], [x+1, y] ].each do |x2, y2|
        if x2 >= 0 && x2 < expanded_map[0].length && y2 >= 0 && y2 < expanded_map.length && expanded_map[y2][x2] == ' '
          next_next_floods << [x2, y2]
        end
      end
    end
    next_floods = next_next_floods
  end
end

def shrink_map(pipes, expanded_map)
  result = []
  pipes.each_with_index do |line, y|
    l = []
    line.each_with_index do |pipe, x|
      l << expanded_map[y*2][x*2]
    end
    result << l
  end
  result
end

def count_empty(map)
  map.map {|line| line.count(' ')}.sum
end

def length_of_loop(pipes, start_x, start_y)
  expanded_map = []
  pipes.each do |line|
    expanded_map << " " * (line.length * 2)
    expanded_map << " " * (line.length * 2)
  end

  length = 0
  previous_x, previous_y = start_x, start_y
  possible_new_positions = inout_of_pipe(pipes, start_x, start_y)
  # Return quickly if our start pipe ends up at incompatible neighbours
  invalid_start= possible_new_positions.any? do |x, y|
    !inout_of_pipe(pipes, x, y).include?([start_x, start_y])
  end
  return nil if invalid_start
  
  x = possible_new_positions.first[0]
  y = possible_new_positions.first[1]

  plot_between(expanded_map, start_x, start_y, x, y)
  length += 1
  while x != start_x || y != start_y
    raise "x is out of range" if x < 0 || x >= pipes[0].length
    raise "y is out of range" if y < 0 || y >= pipes.length

    possible_new_positions = inout_of_pipe(pipes, x, y)
    possible_new_positions.delete([previous_x, previous_y])
    if possible_new_positions.empty?
      puts "Giving up - length #{length}"
      return nil
    elsif possible_new_positions.length > 1
      raise "Too many possible new positions: #{possible_new_positions.inspect}"
    end

    # Now we have to check that we're allowed to enter the new position
    new_position = possible_new_positions.first
    if !inout_of_pipe(pipes, new_position[0], new_position[1]).include?([x, y])
      puts "Cannot enter #{new_position.inspect} from #{x},#{y}"
      return nil
    end

    previous_x, previous_y = x, y
    x, y = possible_new_positions.first
    plot_between(expanded_map, previous_x, previous_y, x, y)
    
    length += 1
  end

  [length, expanded_map]
end

# Try out each of the possible values at S
(PIPE_DIRECTIONS.keys - ['.']).each do |start_suggestion|
  pipes[start_y][start_x] = start_suggestion
  length, expanded_map = length_of_loop(pipes, start_x, start_y)
  if length
    puts "Part 1: #{length / 2}"

    flood_map(expanded_map)
    shrunk_map = shrink_map(pipes, expanded_map)

    puts "Part 2: #{count_empty(shrunk_map)}"
    break
  end
end
