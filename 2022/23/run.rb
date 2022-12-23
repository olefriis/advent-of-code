map = {}

File.readlines('23/input', chomp: true).each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    map[[x, y]] = '#' if char == '#'
  end
end

Direction = Struct.new(:destination, :empty_fields)
DIRECTIONS = [
  Direction.new([0, -1], [[-1, -1], [0, -1], [1, -1]]), # North
  Direction.new([0, 1], [[-1, 1], [0, 1], [1, 1]]), # South
  Direction.new([-1, 0], [[-1, -1], [-1, 0], [-1, 1]]), # West
  Direction.new([1, 0], [[1, -1], [1, 0], [1, 1]]), # East
]

def propose_position(position, map, direction_index)
  neighbours = [
    [-1, -1], [0, -1], [1, -1],
    [-1,  0],          [1,  0],
    [-1,  1], [0,  1], [1,  1]
  ]
  return position if neighbours.none? { |dx, dy| map[[position[0] + dx, position[1] + dy]] }

  4.times do |i|
    direction = DIRECTIONS[(direction_index + i) % 4]
    if direction.empty_fields.none? { |dx, dy| map[[position[0] + dx, position[1] + dy]] }
      return [position[0] + direction.destination[0], position[1] + direction.destination[1]]
    end
  end

  nil
end

def show(map)
  0.upto(11) do |y|
    0.upto(13) do |x|
      if map[[x, y]]
        print '#'
      else
        print '.'
      end
    end
    puts ''
  end
  puts ''
end

direction_index = 0
1000000.times do |i|
  proposed_positions = {}
  map.keys.each do |position|
    proposed_position = propose_position(position, map, direction_index)
    if proposed_position
      proposed_positions[proposed_position] ||= 0
      proposed_positions[proposed_position] += 1
    else
      proposed_positions[position] ||= 0
      proposed_positions[position] += 1
    end
  end

  new_map = {}
  moved = false
  map.keys.each do |position|
    proposed_position = propose_position(position, map, direction_index)
    if !proposed_position || proposed_positions[proposed_position] > 1
      new_map[position] = '#'
    else
      new_map[proposed_position] = '#'
      moved = true if proposed_position != position
    end
  end

  map = new_map
  direction_index = (direction_index + 1) % 4

  if i == 9
    min_x, max_x = map.keys.map(&:first).minmax
    min_y, max_y = map.keys.map(&:last).minmax
    free_space = (max_x - min_x + 1) * (max_y - min_y + 1) - map.size
    puts "Part 1: #{free_space}"
  end

  if !moved
    puts "Part 2: #{i+1}"
    break
  end
end
