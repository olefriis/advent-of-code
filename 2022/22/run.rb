require 'pry'
map = {}

map_input, direction_input = File.read('22/test_input').split("\n\n")
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
  middle_x_min, middle_x_max = map.keys.select {|_, y| y == 0}.map {|x, _| x}.minmax
  middle_y_min, middle_y_max = map.keys.select {|x, _| x == 0}.map {|_, y| y}.minmax

  if position[0] >= middle_x_min && position[0] <= middle_x_max
    if position[1] < middle_y_min
      1 # Top
    elsif position[1] > middle_y_max
      5 # Bottom
    else
      4 # middle
    end
  elsif position[1] >= middle_y_min && position[1] <= middle_y_max 
    if position[0] > middle_x_max
      4
    elsif position[0] < (middle_x_min / 2)
      2
    elsif position[0] < middle_x_min
      3
    else
      raise "Invalid position: #{position}"
    end
  elsif position[0] > middle_x_min && position[1] > middle_y_max
    6
  else
    raise "Invalid position: #{position}"
  end
end

def easy_movement(side1, side2)
  return true if side1 == side2

  [
    [1, 4],
    [2, 3],
    [3, 4],
    [4, 5],
    [5, 6]
  ].include?([side1, side2].sort)
end

def wrap(position, movement, map)
  current_side = side(position, map)
  max_x = map.keys.map {|x, _| x}.max
  max_y = map.keys.map {|_, y| y}.max
  middle_x_min, middle_x_max = map.keys.select {|_, y| y == 0}.map {|x, _| x}.minmax
  middle_y_min, middle_y_max = map.keys.select {|x, _| x == 0}.map {|_, y| y}.minmax

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
  puts "Alter direction #{direction} #{current_side} #{new_side}"
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

  show(movement_map)
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
def square(upper_right, side_length, map)
  result = []
  0.upto(side_length - 1) do |y|
    line = []
    0.upto(side_length - 1) do |x|
      line << map[[upper_right[0] + x, upper_right[1] + y]]
    end
    result << line
  end
  result
end

def place(area, upper_right, map)
  area.each_with_index do |line, y|
    line.each_with_index do |char, x|
      map[[upper_right[0] + x, upper_right[1] + y]] = char
    end
  end
end

def rotate_2d_right(matrix)
  matrix.transpose.map(&:reverse)
end

def place_areas(areas, side_length)
  new_map = {}
  place(areas[0], [2*side_length, 0], new_map)
  place(areas[1], [0, side_length], new_map)
  place(areas[2], [side_length, side_length], new_map)
  place(areas[3], [2*side_length, side_length], new_map)
  place(areas[4], [2*side_length, 2*side_length], new_map)
  place(areas[5], [3*side_length, 2*side_length], new_map)
  new_map
end

def map_example_input(map)
  area1 = square([8, 0], 4, map)
  area2 = square([0, 4], 4, map)
  area3 = square([4, 4], 4, map)
  area4 = square([8, 4], 4, map)
  area5 = square([8, 8], 4, map)
  area6 = square([12, 8], 4, map)
  place_areas([area1, area2, area3, area4, area5, area6], 4)
end

def map_actual_input(map, side_length: 50)
  area1 = square([side_length, 0], side_length, map)
  area2 = rotate_2d_right(square([0, 3*side_length], side_length, map))
  area3 = rotate_2d_right(square([0, 2*side_length], side_length, map))
  area4 = square([side_length, side_length], side_length, map)
  area5 = square([side_length, 2*side_length], side_length, map)
  area6 = rotate_2d_right(rotate_2d_right(square([2*side_length, 0], side_length, map)))
  place_areas([area1, area2, area3, area4, area5, area6], side_length)
end

direction_to_number = {
  [1, 0] => 0,
  [0, 1] => 1,
  [-1, 0] => 2,
  [0, -1] => 3
}

visualize_wrapped_movements(map)
binding.pry

#part2_map = map_example_input(map)
part2_map = map_actual_input(map, side_length: 50)
show(part2_map)
position_x = part2_map.keys.select {|_, y| y == 0}.map{|x, _| x}.min
position = [position_x, 0]
part_2_position, part_2_direction = solve2(position, part2_map, instructions)
part_2_side = side(part_2_position, part2_map)
if part_2_side == 3
  puts 'Inside 3'
  # Get point inside the square
  position_in_square = [part_2_position[0] - 50, part_2_position[1] - 50]
  rotated_back = rotate_left(position_in_square)
  part_2_position = [rotated_back[0], rotated_back[1] + 150]
  part_2_direction = rotate_left(part_2_direction)
end
part_2_direction_number = direction_to_number[part_2_direction]
part2 = 1000 * (part_2_position[1] + 1) + 4 * (part_2_position[0] + 1) + part_2_direction_number
puts "Part 2: #{part2}"
binding.pry

# > part_2_position
# => [105, 29]
# 30227: Too low :-(
# 30228: Too low

# > part_2_position
# => [122, 63]
# So part_2_position = [72, 63]
# 64293: Too low

# > part_2_position
# => [120, 115]
# So part_2_position = [70, 115]
# 116287: Wrong!

# > part_2_position
# => [78, 87]
# So [28, 37] in side 3, which is rotated, so rotating back left it ends at position [37, 22]
# Side 3 is 100 cells down in the real input, so ends up at [37,122]
# > part_2_direction
# => [-1, 0]
# But we have to rotate left. So pointing left originally, now pointing down.
# part_2_position = [37,122]
# part_2_direction = [0, 1]
# 123154: Wrong
# Whoops! Forgot
#> part_2_direction_number = direction_to_number[part_2_direction]
#=> 1
# 123153: Wrong