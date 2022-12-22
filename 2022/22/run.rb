require 'pry'
map = {}

test = false
filename = test ? '22/test_input' : '22/input'
TILE_SIZE = test ? 4 : 50
LEFT = [-1, 0]
UP = [0, -1]
RIGHT = [1, 0]
DOWN = [0, 1]

map_input, direction_input = File.read(filename).split("\n\n")
map_input.lines.map(&:chomp).each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    map[[x, y]] = char unless char == ' '
  end
end

current_number = 0
instructions = []
direction_input.chars.each do |char|
  if ['R', 'L'].include?(char)
    instructions << current_number
    instructions << char
    current_number = 0
  else
    current_number = current_number * 10 + char.to_i
  end
end
instructions << current_number

def solve1(position, map, instructions)
  movements = [
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, -1]
  ]
  direction = 0

  instructions.each do |instruction|
    if instruction == 'R'
      direction = (direction + 1) % 4
    elsif instruction == 'L'
      direction = (direction - 1) % 4
    else
      instruction.times do
        movement = movements[direction]
        new_position = [position[0] + movement[0], position[1] + movement[1]]
        new_tile = map[[new_position[0], new_position[1]]]
        if !new_tile
          # Wrap around
          if direction == 0
            # Facing right, so taking the leftmost tile with same y
            new_x = map.keys.select {|_, y| y == position[1]}.map{|x, _| x}.min
            new_position[0] = new_x
          elsif direction == 2
            # Facing left, so taking the rightmost tile with same y
            new_x = map.keys.select {|_, y| y == position[1]}.map{|x, _| x}.max
            new_position[0] = new_x
          elsif direction == 1
            # Facing down, so taking the topmost tile with same x
            new_y = map.keys.select {|x, _| x == position[0]}.map{|_, y| y}.min
            #puts "New y: #{new_y}"
            new_position[1] = new_y
          elsif direction == 3
            # Facing up, so taking the bottommost tile with same x
            new_y = map.keys.select {|x, _| x == position[0]}.map{|_, y| y}.max
            new_position[1] = new_y
          else
            raise 'Invalid direction'
          end
        end
        new_tile = map[[new_position[0], new_position[1]]]
        position = new_position if map[new_position] != '#'
      end
    end
  end
  [position, direction]
end

def side(position, map)
  x_section, y_section = position[0] / TILE_SIZE, position[1] / TILE_SIZE

  sections = {
    [2, 0] => 1,
    [0, 1] => 2,
    [1, 1] => 3,
    [2, 1] => 4,
    [2, 2] => 5,
    [3, 2] => 6,
  }
  sections[[x_section, y_section]] || raise("Invalid position #{position} - section #{x_section}, #{y_section}")
end

def wrap(position, movement, map)
  x_section, y_section = position[0] / TILE_SIZE, position[1] / TILE_SIZE

  current_side = side(position, map)
  max_x = TILE_SIZE * 4 - 1
  max_y = TILE_SIZE * 3 - 1
  middle_x_min = TILE_SIZE * 2
  middle_x_max = TILE_SIZE * 3 - 1
  middle_y_min = TILE_SIZE
  middle_y_max = TILE_SIZE * 2 - 1

  if movement == [1, 0]
    case current_side
    when 1
      [max_x, max_y - position[1]]
    when 4
      [max_x - (position[1] - middle_y_min), middle_y_max + 1]
    when 6
      [middle_x_max, max_y - position[1]]
    else
      raise "Invalid side #{current_side}"
    end
  elsif movement == [-1, 0]
    case current_side
    when 1
      [(middle_x_min / 2) + position[1], middle_y_min]
    when 2
      [max_x - (position[1] - middle_y_min), max_y]
    when 5
      [(middle_x_min / 2) + (max_y - position[1]), middle_y_max]
    else
      raise "Invalid side #{current_side}"
    end
  elsif movement == [0, 1]
    case current_side
    when 2
      [middle_x_max - position[0], max_y]
    when 3
      [middle_x_min, max_y - (position[0] - (middle_x_min / 2))]
    when 5
      [(middle_x_min / 2) - (position[0] - middle_x_min) - 1, middle_y_max]
    when 6
      [0, middle_y_min + (max_x - position[0])]
    else
      raise "Invalid side #{current_side}"
    end
  elsif movement == [0, -1]
    case current_side
    when 1
      [(middle_x_min / 2) - (position[0] - middle_x_min) - 1, middle_y_min]
    when 2
      [middle_x_max - position[0], 0]
    when 3
      [middle_x_min, position[0] - (middle_x_min / 2)]
    when 6
      [middle_x_max, middle_y_min + (max_x - position[0])]
    else
      raise "Invalid side #{current_side}"
    end
  else
    raise "Invalid movement #{movement}"
  end
end

def rotate_right(movement)
  [-movement[1], movement[0]]
end

def rotate_180(movement)
  rotate_right(rotate_right(movement))
end

def rotate_left(movement)
  rotate_right(rotate_right(rotate_right(movement)))
end

def alter_direction(direction, current_side, new_side)
  case current_side
  when 1
    case new_side
    when 2
      rotate_180(direction)
    when 3
      rotate_left(direction)
    when 6
      rotate_180(direction)
    else
      raise "invalid side #{new_side}"
    end
  when 2
    case new_side
    when 1
      rotate_180(direction)
    when 5
      rotate_180(direction)
    when 6
      rotate_right(direction)
    else
      raise "invalid side #{new_side}"
    end
  when 3
    case new_side
    when 1
      rotate_right(direction)
    when 5
      rotate_left(direction)
    else
      raise "invalid side #{new_side}"
    end
  when 4
    case new_side
    when 6
      rotate_right(direction)
    else
      raise "invalid side #{new_side}"
    end
  when 5
    case new_side
    when 3
      rotate_right(direction)
    when 2
      rotate_180(direction)
    else
      raise "invalid side #{new_side}"
    end
  when 6
    case new_side
    when 1
      rotate_180(direction)
    when 2
      rotate_left(direction)
    when 4
      rotate_left(direction)
    else
      raise "invalid side #{new_side}"
    end
  else
    raise "invalid side #{current_side}"
  end
end

def solve2(position, map, instructions)
  movement_map = map.dup
  direction = [1, 0]

  direction_to_debug_info = {
    [1, 0] => '>',
    [0, 1] => 'v',
    [-1, 0] => '<',
    [0, -1] => '^'
  }

  instructions.each do |instruction|
    #puts "Position: #{position}, Direction: #{direction}, Instruction: #{instruction}"
    if instruction == 'R'
      direction = rotate_right(direction)
    elsif instruction == 'L'
      direction = rotate_right(rotate_right(rotate_right(direction)))
    else
      instruction.times do
        raise 'Hey!!' if map[position] != '.'
        new_position = [position[0] + direction[0], position[1] + direction[1]]
        new_tile = map[new_position]

        current_side = side(position, map)
        should_wrap = !new_tile
        if should_wrap
          new_position = wrap(position, direction, map)
        end

        new_tile = map[new_position]
        movement_map[position] = direction_to_debug_info[direction]

        if map[new_position] != '#'
          position = new_position
          new_side = side(position, map)
          direction = alter_direction(direction, current_side, new_side) if should_wrap
        end
      end
    end
  end

  #show(movement_map)
  [position, direction]
end

def show(map)
  max_x = map.keys.map {|x, _| x}.max
  max_y = map.keys.map {|_, y| y}.max
  0.upto(max_y) do |y|
    0.upto(max_x) do |x|
      char = map[[x, y]]
      if char
        print char
      else
        print ' ' 
      end
    end
    puts ''
  end
end

def visualize_wrapped_movements(map)
  max_x = map.keys.map {|x, _| x}.max
  max_y = map.keys.map {|_, y| y}.max

  direction_to_debug_info = {
    [1, 0] => '>',
    [0, 1] => 'v',
    [-1, 0] => '<',
    [0, -1] => '^'
  }

  puts "Going down"
  direction = [0, 1]
  0.upto(max_x) do |x|
    down_map = map.dup
    y = map.keys.select {|x1, _| x1 == x}.map {|_, y1| y1}.max
    position = [x, y]
    new_position = wrap(position, direction, map)
    current_side = side(position, map)
    new_side = side(new_position, map)
    down_map[position] = direction_to_debug_info[direction]
    down_map[new_position] = direction_to_debug_info[alter_direction(direction, current_side, new_side)]
    show(down_map)
  end

  puts "Going up"
  direction = [0, -1]
  0.upto(max_x) do |x|
    down_map = map.dup
    y = map.keys.select {|x1, _| x1 == x}.map {|_, y1| y1}.min
    position = [x, y]
    new_position = wrap(position, direction, map)
    current_side = side(position, map)
    new_side = side(new_position, map)
    down_map[position] = direction_to_debug_info[direction]
    down_map[new_position] = direction_to_debug_info[alter_direction(direction, current_side, new_side)]
    show(down_map)
  end

  puts "Going right"
  direction = [1, 0]
  0.upto(max_y) do |y|
    down_map = map.dup
    x = map.keys.select {|_, y1| y1 == y}.map {|x1, _| x1}.max
    position = [x, y]
    new_position = wrap(position, direction, map)
    current_side = side(position, map)
    new_side = side(new_position, map)
    down_map[position] = direction_to_debug_info[direction]
    down_map[new_position] = direction_to_debug_info[alter_direction(direction, current_side, new_side)]
    show(down_map)
  end

  puts "Going left"
  direction = [-1, 0]
  0.upto(max_y) do |y|
    down_map = map.dup
    x = map.keys.select {|_, y1| y1 == y}.map {|x1, _| x1}.min
    position = [x, y]
    new_position = wrap(position, direction, map)
    current_side = side(position, map)
    new_side = side(new_position, map)
    down_map[position] = direction_to_debug_info[direction]
    down_map[new_position] = direction_to_debug_info[alter_direction(direction, current_side, new_side)]
    show(down_map)
  end
end

position_x = map.keys.select {|_, y| y == 0}.map{|x, _| x}.min
position = [position_x, 0]

part1_position, part1_direction = solve1(position, map, instructions)

part1 = 1000 * (part1_position[1] + 1) + 4 * (part1_position[0] + 1) + part1_direction
puts "Part 1: #{part1}"

# GRRR! Real input has a different layout than the example input
def copy_tile(upper_right, map)
  result = []
  0.upto(TILE_SIZE - 1) do |y|
    line = []
    0.upto(TILE_SIZE - 1) do |x|
      line << map[[upper_right[0] + x, upper_right[1] + y]]
    end
    result << line
  end
  result
end

def place_tile(area, upper_right, map)
  area.each_with_index do |line, y|
    line.each_with_index do |char, x|
      map[[upper_right[0] + x, upper_right[1] + y]] = char
    end
  end
end

def rotate_2d_right(matrix)
  matrix.transpose.map(&:reverse)
end

def place_tiles(tiles)
  new_map = {}
  place_tile(tiles[0], [2*TILE_SIZE, 0], new_map)
  place_tile(tiles[1], [0, TILE_SIZE], new_map)
  place_tile(tiles[2], [TILE_SIZE, TILE_SIZE], new_map)
  place_tile(tiles[3], [2*TILE_SIZE, TILE_SIZE], new_map)
  place_tile(tiles[4], [2*TILE_SIZE, 2*TILE_SIZE], new_map)
  place_tile(tiles[5], [3*TILE_SIZE, 2*TILE_SIZE], new_map)
  new_map
end

def map_example_input(map)
  area1 = copy_tile([2*TILE_SIZE, 0], map)
  area2 = copy_tile([0, TILE_SIZE], map)
  area3 = copy_tile([TILE_SIZE, TILE_SIZE], map)
  area4 = copy_tile([2*TILE_SIZE, TILE_SIZE], map)
  area5 = copy_tile([2*TILE_SIZE, 2*TILE_SIZE], map)
  area6 = copy_tile([3*TILE_SIZE, 2*TILE_SIZE], map)
  place_tiles([area1, area2, area3, area4, area5, area6])
end

def map_actual_input(map)
  area1 = copy_tile([TILE_SIZE, 0], map)
  area2 = rotate_2d_right(copy_tile([0, 3*TILE_SIZE], map))
  area3 = rotate_2d_right(copy_tile([0, 2*TILE_SIZE], map))
  area4 = copy_tile([TILE_SIZE, TILE_SIZE], map)
  area5 = copy_tile([TILE_SIZE, 2*TILE_SIZE], map)
  area6 = rotate_2d_right(rotate_2d_right(copy_tile([2*TILE_SIZE, 0], map)))
  place_tiles([area1, area2, area3, area4, area5, area6])
end

direction_to_number = {
  [1, 0] => 0,
  [0, 1] => 1,
  [-1, 0] => 2,
  [0, -1] => 3
}

#visualize_wrapped_movements(map)

part2_map = test ? map_example_input(map) : map_actual_input(map)
position_x = part2_map.keys.select {|_, y| y == 0}.map{|x, _| x}.min
position = [position_x, 0]
part_2_position, part_2_direction = solve2(position, part2_map, instructions)
part_2_side = side(part_2_position, part2_map)
if !test
  if part_2_side == 3
    puts 'Inside 3'
    # Get point inside the square
    position_in_square = [part_2_position[0] - TILE_SIZE, part_2_position[1] - TILE_SIZE]
    rotated_back = rotate_left(position_in_square)
    part_2_position = [rotated_back[0], rotated_back[1] + 3*TILE_SIZE]
    part_2_direction = rotate_left(part_2_direction)
    puts 'I have an answer for you, but it will probably be off with 1000. See run_2.rb instead.'
  else
    puts 'Sorry, not inside section 3. You will have to do some work yourself now...'
  end
end
part_2_direction_number = direction_to_number[part_2_direction]
part2 = 1000 * (part_2_position[1] + 1) + 4 * (part_2_position[0] + 1) + part_2_direction_number
puts "Part 2: #{part2}"
