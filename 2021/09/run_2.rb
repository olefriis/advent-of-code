require 'set'
lines = File.readlines('input').map(&:strip).map {|line| line.split('').map(&:to_i)}

basins = []

Point = Struct.new(:x, :y)

def neighbours(lines, point)
  x, y = point.x, point.y
  neighbours = []
  neighbours << Point.new(x-1, y) if x > 0
  neighbours << Point.new(x+1, y) if x < lines[y].length - 1
  neighbours << Point.new(x, y-1) if y > 0
  neighbours << Point.new(x, y+1) if y < lines.length - 1
  neighbours
end

def points_in_basin(lines, point)
  seen = Set.new
  seen << point
  edge = neighbours(lines, point).filter {|neighbour| lines[neighbour.y][neighbour.x] < 9}

  while edge.count > 0
    new_edge = Set.new
    edge.each do |edge_point|
      seen << edge_point
      seen_neighbours = neighbours(lines, edge_point).filter {|p| seen.include?(p)}
      has_lower_seen_neighbour = seen_neighbours.any? {|neighbour| lines[neighbour.y][neighbour.x] < lines[edge_point.y][edge_point.x]}
      if has_lower_seen_neighbour
        seen << edge_point
        neighbours(lines, edge_point).filter {|p| !seen.include?(p)}.each do |new_edge_point|
          if lines[new_edge_point.y][new_edge_point.x] < 9
            new_edge << new_edge_point
          end
        end
      end
    end
    edge = new_edge - edge - seen
  end
  seen
end

low_points = []
(0...lines.length).each do |y|
  (0...lines[y].length).each do |x|
    neighbours = []
    neighbours << lines[y][x-1] if x > 0
    neighbours << lines[y][x+1] if x < lines[y].length - 1
    neighbours << lines[y-1][x] if y > 0
    neighbours << lines[y+1][x] if y < lines.length - 1

    low_points << Point.new(x, y) if neighbours.min > lines[y][x]
  end
end

basins = low_points.map {|point| points_in_basin(lines, point)}
basins = basins.sort_by {|basin| -basin.length}

puts basins[0].length * basins[1].length * basins[2].length
