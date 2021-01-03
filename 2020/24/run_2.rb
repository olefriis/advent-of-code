require 'set'
lines = File.readlines('test_input').map(&:strip)

Position = Struct.new(:x, :y) do
  def plus(other)
    Position.new(other.x + self.x, other.y + self.y)
  end
end

flipped_tiles = Set.new
lines.each do |line|
  position = Position.new(0, 0)
  while line.length > 0
    if line.start_with?('ne')
      position.x += 1
      position.y -= 1
      line[0...2] = ''
    elsif line.start_with?('nw')
      position.y -= 1
      line[0...2] = ''
    elsif line.start_with?('se')
      position.y += 1
      line[0...2] = ''
    elsif line.start_with?('sw')
      position.y += 1
      position.x -= 1
      line[0...2] = ''
    elsif line.start_with?('e')
      position.x += 1
      line[0...1] = ''
    elsif line.start_with?('w')
      position.x -= 1
      line[0...1] = ''
    else
      raise "Weird line: #{line}"
    end
  end

  if flipped_tiles.include?(position)
    flipped_tiles.delete(position)
  else
    flipped_tiles.add(position)
  end
end

neighbour_positions = [
  Position.new(1, -1),
  Position.new(0, -1),
  Position.new(0, 1),
  Position.new(-1, 1),
  Position.new(1, 0),
  Position.new(-1, 0)
]
100.times do |day|
  new_flipped_tiles = Set.new()
  tiles_to_consider = Set.new(flipped_tiles.flat_map do |position|
    neighbour_positions.map {|neighbour| neighbour.plus(position)} + [position]
  end)

  new_flipped_tiles = Set.new()
  tiles_to_consider.each do |position|
    neightbour_black = neighbour_positions.select {|neighbour| flipped_tiles.include?(neighbour.plus(position))}.count
    if flipped_tiles.include?(position) # We're black
      if neightbour_black == 0 || neightbour_black > 2
        # Switch to white, which means we shouldn't be included in the set
      else
        new_flipped_tiles << position # We stay black
      end
    else # We're white
      if neightbour_black == 2
        new_flipped_tiles << position # We flip to black
      end
    end
  end
  flipped_tiles = new_flipped_tiles

  puts "Day #{day+1}: #{flipped_tiles.count}"
end

puts flipped_tiles.count

# 4206 ?