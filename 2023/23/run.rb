$grid = File.readlines("23/input").map(&:strip).map(&:chars)

def within_grid(x, y)
  x >= 0 && y >= 0 && x < $grid[0].length && y < $grid.length
end

def neighbours(x, y)
  [[x, y-1], [x, y+1], [x-1, y], [x+1, y]].select {|x2, y2| within_grid(x2, y2) && $grid[y2][x2] != "#"}
end

$junctions = Set.new
$grid.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    next if x == 0 || y == 0 || x == $grid[0].length - 1 || y == $grid.length - 1 || $grid[y][x] == '#'

    $junctions << [x, y] if neighbours(x, y).count > 2
  end
end
$junctions << [$grid[0].index('.'), 0]
$junctions << [$grid[$grid.length - 1].index('.'), $grid[0].length - 1]

def junction_connections(part2)
  result = {}
  $junctions.each do |junction_x, junction_y|
    neighbours(junction_x, junction_y).each do |x, y|
      seen = [[junction_x, junction_y]].to_set
      distance = 1
      loop do
        seen << [x, y]
        if $junctions.include?([x, y])
          result[[junction_x, junction_y]] ||= {}
          result[[junction_x, junction_y]][[x, y]] = distance
          break
        end
        next_positions = neighbours(x, y).reject { |x2, y2| seen.include?([x2, y2]) }
        if !part2
          next_positions = next_positions
            .reject { |x2, y2| $grid[y2][x2] == ">" && x2 == x-1 }
            .reject { |x2, y2| $grid[y2][x2] == "v" && y2 == y-1 }
        end
        break if next_positions.empty? # Dead end

        distance += 1
        x, y = next_positions.first
      end
    end
  end
  result
end

def longest_path(x, y, connections, seen=[[x, y]].to_set)
  return 0 if x == $grid.length - 2 && y == $grid[0].length - 1

  junctions_reachable = connections[[x, y]].keys.reject {|pos| seen.include?(pos)}
  junctions_reachable.map do |x2, y2|
    seen << [x2, y2]
    distance_to_next_junction = connections[[x, y]][[x2, y2]]
    result = distance_to_next_junction + longest_path(x2, y2, connections, seen)
    seen.delete([x2, y2])
    result
  end.compact.max || -10000000
end

puts "Part 1: #{longest_path(1, 0, junction_connections(false))}"
puts "Part 2: #{longest_path(1, 0, junction_connections(true))}"
