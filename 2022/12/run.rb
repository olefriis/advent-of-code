Position = Struct.new(:x, :y)

chars = File.readlines('12/input').map(&:chomp).map(&:chars)
heights = chars.map { |line| line.map { |char| char.ord - 'a'.ord } }
start, destination = nil, nil
chars.each_with_index do |line, y|
  line.each_with_index do |char, x|
    if char == 'S'
      start = Position.new(x, y)
      heights[y][x] = 0
    elsif char == 'E'
      destination = Position.new(x, y)
      heights[y][x] = 'z'.ord - 'a'.ord
    end
  end
end

def shortest_path(start, destination, heights)
  edge = { start => 0 }
  visited = { start => 0 }

  while edge.any?
    pos, turns = edge.min_by { |_, v| v }
    edge.delete(pos)
    visited[pos] = turns
    [Position.new(pos.x-1, pos.y), Position.new(pos.x, pos.y-1), Position.new(pos.x+1, pos.y), Position.new(pos.x, pos.y+1)]
      .filter { |p| p.x >= 0 && p.y >= 0 && p.x < heights.first.size && p.y < heights.size }
      .filter { |p| !visited[p] }
      .filter { |p| heights[p.y][p.x] <= heights[pos.y][pos.x] + 1 }
      .each { |p| edge[p] = turns + 1}
  end
  visited[destination]
end

puts "Part 1: #{shortest_path(start, destination, heights)}"

shortest_overall = nil
heights.each_with_index do |line, y|
  line.each_with_index do |height, x|
    next if height != 0 || (x == start.x && y == start.y)
    shortest_from_here = shortest_path(Position.new(x, y), destination, heights)
    next unless shortest_from_here
    shortest_overall = [shortest_overall, shortest_from_here].compact.min
  end
end

puts "Part 2: #{shortest_overall}"
