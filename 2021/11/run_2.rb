require 'set'
grid = File.readlines('input').map(&:strip).map { |line| line.split('').map(&:to_i) }

Pos = Struct.new(:x, :y)

def print_grid(grid)
  puts grid.map { |row| row.join('') }.join("\n")
end

def neighbours(grid, position)
  [[-1, -1], [0, -1], [1, -1],
   [-1,  0],          [1,  0],
   [-1,  1], [0,  1], [1,  1]]
    .map { |dx, dy| Pos.new(position.x + dx, position.y + dy) }
    .filter { |pos| pos.y >= 0 && pos.y < grid.size && pos.x >= 0 && pos.x < grid[0].size }
end


def iterate(grid)
  has_flashed = Set.new
  flashing = []
  (0...(grid.size)).each do |y|
    (0...(grid[y].size)).each do |x|
      grid[y][x] += 1
      flashing << Pos.new(x, y) if grid[y][x] > 9
    end
  end

  while flashing.length > 0
    new_flashing = []
    flashing.each do |pos|
      if !has_flashed.include?(pos)
        has_flashed << pos
        neighbours(grid, pos).each do |neighbour|
          grid[neighbour.y][neighbour.x] += 1
          new_flashing << neighbour if grid[neighbour.y][neighbour.x] > 9
        end
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

1000.times do |i|
  iterate(grid)

  if grid.map(&:sum).sum == 0
    puts i+1
    exit 0
  end
end

puts 'Did not find any syncrhonous flashing'
