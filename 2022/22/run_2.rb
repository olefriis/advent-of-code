require 'pry'
map = {}

test = false
filename = test ? '22/test_input2' : '22/input'
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

def wrap(position, direction, map)
  x_section, y_section = position[0] / TILE_SIZE, position[1] / TILE_SIZE
  
  case direction
  when LEFT
    case y_section
    when 0
      [[0, 3*TILE_SIZE - position[1] - 1], rotate_180(direction)]
    when 1
      [[position[1] - TILE_SIZE, TILE_SIZE * 2], rotate_left(direction)]
    when 2
      [[TILE_SIZE, 3*TILE_SIZE - position[1] - 1], rotate_180(direction)]
    when 3
      [[TILE_SIZE + (position[1] - 3*TILE_SIZE), 0], rotate_left(direction)]
    end
  when RIGHT
    case y_section
    when 0
      [[2*TILE_SIZE - 1, 3*TILE_SIZE - position[1] - 1], rotate_180(direction)]
    when 1
      [[TILE_SIZE + position[1], TILE_SIZE - 1], rotate_left(direction)]
    when 2
      [[3*TILE_SIZE - 1, 3*TILE_SIZE - position[1] - 1], rotate_180(direction)]
    when 3
      [[position[1] - 2*TILE_SIZE, 3*TILE_SIZE - 1], rotate_left(direction)]
    end
  when UP
    case x_section
    when 0
      [[TILE_SIZE, TILE_SIZE + position[0]], rotate_right(direction)]
    when 1
      [[0, 2*TILE_SIZE + position[0]], rotate_right(direction)]
    when 2
      [[position[0] - 2*TILE_SIZE, 4*TILE_SIZE - 1], direction]
    end
  when DOWN
    case x_section
    when 0
      [[2*TILE_SIZE + position[0], 0], direction]
    when 1
      [[TILE_SIZE - 1, 2*TILE_SIZE + position[0]], rotate_right(direction)]
    when 2
      [[2*TILE_SIZE - 1, position[0] - TILE_SIZE], rotate_right(direction)]
    end
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

        should_wrap = !new_tile
        if should_wrap
          new_position, new_direction = wrap(position, direction, map)
        end

        new_tile = map[new_position]
        movement_map[position] = direction_to_debug_info[direction]

        if map[new_position] != '#'
          position = new_position
          direction = new_direction if should_wrap
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
    new_position, new_direction = wrap(position, direction, map)
    down_map[position] = direction_to_debug_info[direction]
    down_map[new_position] = direction_to_debug_info[new_direction]
    show(down_map)
  end

  puts "Going up"
  direction = [0, -1]
  0.upto(max_x) do |x|
    down_map = map.dup
    y = map.keys.select {|x1, _| x1 == x}.map {|_, y1| y1}.min
    position = [x, y]
    new_position = wrap(position, direction, map)
    new_position, new_direction = wrap(position, direction, map)
    down_map[position] = direction_to_debug_info[direction]
    down_map[new_position] = direction_to_debug_info[new_direction]
    show(down_map)
  end

  puts "Going right"
  direction = [1, 0]
  0.upto(max_y) do |y|
    down_map = map.dup
    x = map.keys.select {|_, y1| y1 == y}.map {|x1, _| x1}.max
    position = [x, y]
    new_position = wrap(position, direction, map)
    new_position, new_direction = wrap(position, direction, map)
    down_map[position] = direction_to_debug_info[direction]
    down_map[new_position] = direction_to_debug_info[new_direction]
    show(down_map)
  end

  puts "Going left"
  direction = [-1, 0]
  0.upto(max_y) do |y|
    down_map = map.dup
    x = map.keys.select {|_, y1| y1 == y}.map {|x1, _| x1}.min
    position = [x, y]
    new_position, new_direction = wrap(position, direction, map)
    down_map[position] = direction_to_debug_info[direction]
    down_map[new_position] = direction_to_debug_info[new_direction]
    show(down_map)
  end
end

direction_to_number = {
  [1, 0] => 0,
  [0, 1] => 1,
  [-1, 0] => 2,
  [0, -1] => 3
}

#visualize_wrapped_movements(map)

position_x = map.keys.select {|_, y| y == 0}.map{|x, _| x}.min
position = [position_x, 0]
part_2_position, part_2_direction = solve2(position, map, instructions)
part_2_direction_number = direction_to_number[part_2_direction]
part2 = 1000 * (part_2_position[1] + 1) + 4 * (part_2_position[0] + 1) + part_2_direction_number
puts "Part 2: #{part2}"
