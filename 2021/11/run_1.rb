require 'set'
grid = File.readlines('input').map(&:strip).map { |line| line.split('').map(&:to_i) }

Pos = Struct.new(:x, :y)

def print_grid(grid)
  puts grid.map { |row| row.join('') }.join("\n")
end

def neighbours(grid, position)
  result = []
  [[-1, -1], [0, -1], [1, -1],
   [-1,  0],          [1,  0],
   [-1,  1], [0,  1], [1,  1]].each do |dx, dy|
    pos = Pos.new(position.x + dx, position.y + dy)
    result << pos if pos.y >= 0 && pos.y < grid.size && pos.x >= 0 && pos.x < grid[pos.y].size
  end
  result
end

@total_flashes = 0

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
        @total_flashes += 1
        has_flashed << pos
        neighbours(grid, pos).each do |neighbour|
          grid[neighbour.y][neighbour.x] += 1
          new_flashing << neighbour if grid[neighbour.y][neighbour.x] > 9 && !has_flashed.include?(neighbour)
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

print_grid(grid)

100.times do |i|
  iterate(grid)
  #puts "\nAfter step #{i+1}"
  #print_grid(grid)
end

puts @total_flashes
