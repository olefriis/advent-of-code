require 'set'
grid = File.readlines('input').map(&:strip).map { |line| line.split('').map(&:to_i) }

Pos = Struct.new(:x, :y)

def neighbours(grid, position)
  [[-1, -1], [0, -1], [1, -1],
   [-1,  0],          [1,  0],
   [-1,  1], [0,  1], [1,  1]]
    .map { |dx, dy| Pos.new(position.x + dx, position.y + dy) }
    .filter { |pos| pos.y >= 0 && pos.y < grid.size && pos.x >= 0 && pos.x < grid[0].size }
end

def iterate(grid)
  has_flashed, flashing = Set.new, Set.new
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      grid[y][x] += 1
      flashing << Pos.new(x, y) if grid[y][x] > 9
    end
  end

  while flashing.length > 0
    new_flashing = Set.new
    (flashing - has_flashed).each do |pos|
      @total_flashes += 1
      has_flashed << pos
      neighbours(grid, pos).each do |neighbour|
        grid[neighbour.y][neighbour.x] += 1
        new_flashing << neighbour if grid[neighbour.y][neighbour.x] > 9 && !has_flashed.include?(neighbour)
      end
    end

    flashing = new_flashing
  end

  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      if grid[y][x] > 9
        grid[y][x] = 0
      end
    end
  end
end

@total_flashes = 0
100.times { |i| iterate(grid) }
puts @total_flashes
