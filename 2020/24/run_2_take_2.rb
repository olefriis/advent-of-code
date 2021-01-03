require 'set'

Position = Struct.new(:x, :y) do
  def plus(other)
    Position.new(other.x + x, other.y + y)
  end
end

directions = {
  'ne' => Position.new(1, -1),
  'nw' => Position.new(0, -1),
  'se' => Position.new(0, 1),
  'sw' => Position.new(-1, 1),
  'e' => Position.new(1, 0),
  'w' => Position.new(-1, 0)
}
neighbour_positions = directions.values

# Initial population
black_tiles = Set.new
File.readlines('input').map(&:strip).each do |line|
  position = Position.new(0, 0)
  while line.length > 0
    direction = directions.keys.find {|direction| line.start_with?(direction)}
    raise "Weird line: #{line}" unless direction
    position = position.plus(directions[direction])
    line[0...direction.length] = ''
  end
  black_tiles.delete(position) unless black_tiles.add?(position)
end

# Part 1 answer
puts "Starting with #{black_tiles.count} black tiles"

# Iterate for 100 days
100.times do |day|
  tiles_to_consider = Set.new(black_tiles.flat_map do |position|
    neighbour_positions.map {|neighbour| neighbour.plus(position)} + [position]
  end)

  black_tiles = tiles_to_consider.keep_if do |position|
    neightbour_black = neighbour_positions.count {|neighbour| black_tiles.include?(neighbour.plus(position))}
    black = black_tiles.include?(position)

    neightbour_black == 2 || (black && neightbour_black == 1)
  end

  puts "Day #{day+1}: #{black_tiles.count}"
end
