require 'pry'
$grid = File.readlines("23/input").map(&:strip).map(&:chars)

$current_max_seen = 0
$current_max_seen_path = Set.new

def longest_distance(x, y, seen, distance=0)
  if x == $grid[0].length - 2 && y == $grid.length - 1
    puts "Found a path of length #{distance}"
    if distance > $current_max_seen
      $current_max_seen_path = seen.dup
    end
    return 0
  end

  possibilities = []
  [[x, y + 1], [x, y - 1], [x + 1, y], [x - 1, y]].each do |next_x, next_y|
    next if seen.include?([next_x, next_y])
    next if $grid[next_y][next_x] == "#"
    next if next_x < 0 || next_y < 0 || next_x >= $grid[0].length || next_y >= $grid.length

    walked = 1
    if $grid[next_y][next_x] == ">"
      next if next_x == x-1 # We cannot go back through a >
      walked += 1
      next_x += 1
    elsif $grid[next_y][next_x] == "v"
      next if next_y == y-1 # We cannot go back through a v
      walked += 1
      next_y += 1
    end
    seen << [x, y]
    possibilities << walked + longest_distance(next_x, next_y, seen, distance + walked)
    seen.delete([x, y])
  end
  possibilities.max || -1
end

puts "Part 1: #{longest_distance(1, 0, Set.new)}"

$grid.each_with_index do |row, y|
  line = []
  row.each_with_index do |cell, x|
    if $current_max_seen_path.include?([x, y])
      line << 'O'
    else
      line << cell
    end
  end
  puts line.join('')
end

binding.pry
