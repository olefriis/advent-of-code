original_grid = File.readlines('input').map { |line| line.strip.split('').map(&:to_i) }

grid = []
5.times do |repeat_y|
  original_grid.length.times do |y|
    line = []
    5.times do |repeat_x|
      original_grid[y].length.times do |x|
        original_entry = original_grid[y][x]
        new_entry = original_entry + repeat_x + repeat_y
        while new_entry > 9
          new_entry -= 9
        end
        line << new_entry
      end
    end
    grid << line
  end
end

Pos = Struct.new(:x, :y)
visited = {}

def visit(pos, risk, grid, visited, edge)
  return if visited[pos]
  visited[pos] = risk
  neighbours = [[0, -1], [-1, 0], [0, 1], [1, 0]].map do |dx, dy|
    Pos.new(pos.x + dx, pos.y + dy)
  end.filter do |neighbour|
    neighbour.y >= 0 && neighbour.y < grid.size && neighbour.x >= 0 && neighbour.x < grid[0].size
  end.filter do |neighbour|
    !visited.has_key?(neighbour)
  end

  neighbours.each do |neighbour|
    neighbour_risk = risk + grid[neighbour.y][neighbour.x]
    edge[neighbour] = neighbour_risk if !edge[neighbour] || edge[neighbour] > neighbour_risk
  end
end

edge = {
  Pos.new(0, 0) => 0
}

while edge.length > 0
  edge_to_take = edge.keys.min_by { |pos| edge[pos] }

  visit(edge_to_take, edge[edge_to_take], grid, visited, edge)
  edge.delete(edge_to_take)
end

puts visited[Pos.new(grid[0].length - 1, grid.length - 1)]
