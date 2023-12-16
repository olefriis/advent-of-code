require 'pry'
grid = File.readlines("16/input").map(&:strip).map(&:chars)

BeamPos = Struct.new(:x, :y, :dx, :dy)

def energy(initial_beam, grid)
  edge = [initial_beam]
  seen = Set.new

  while !edge.empty?
    new_edge = Set.new
    edge.each do |pos|
      next if seen.include?(pos)
      seen << pos

      next_x = pos.x + pos.dx
      next_y = pos.y + pos.dy
      next if next_x < 0 || next_x >= grid[0].size || next_y < 0 || next_y >= grid.size

      dxy = [pos.dx, pos.dy]
      c = grid[next_y][next_x]
      if c =='.'
        new_edge << BeamPos.new(next_x, next_y, pos.dx, pos.dy)
      elsif c == '-'
        if pos.dx == 0
          new_edge << BeamPos.new(next_x, next_y, 1, 0)
          new_edge << BeamPos.new(next_x, next_y, -1, 0)
        else
          new_edge << BeamPos.new(next_x, next_y, pos.dx, pos.dy)
        end
      elsif c == '|'
        if pos.dy == 0
          new_edge << BeamPos.new(next_x, next_y, 0, 1)
          new_edge << BeamPos.new(next_x, next_y, 0, -1)
        else
          new_edge << BeamPos.new(next_x, next_y, pos.dx, pos.dy)
        end
      elsif c == '/'
        case dxy
        when [0, -1] # Upwards
          new_edge << BeamPos.new(next_x, next_y, 1, 0)
        when [0, 1] # Downwards
          new_edge << BeamPos.new(next_x, next_y, -1, 0)
        when [-1, 0] # Leftwards
          new_edge << BeamPos.new(next_x, next_y, 0, 1)
        when [1, 0] # Rightwards
          new_edge << BeamPos.new(next_x, next_y, 0, -1)
        else
          raise "Impossible"
        end
      elsif c == '\\'
        case dxy
        when [0, -1] # Upwards
          new_edge << BeamPos.new(next_x, next_y, -1, 0)
        when [0, 1] # Downwards
          new_edge << BeamPos.new(next_x, next_y, 1, 0)
        when [-1, 0] # Leftwards
          new_edge << BeamPos.new(next_x, next_y, 0, -1)
        when [1, 0] # Rightwards
          new_edge << BeamPos.new(next_x, next_y, 0, 1)
        else
          raise "Impossible"
        end
      end
    end

    edge = new_edge
  end

  visited = seen.map { |pos| [pos.x, pos.y] }.uniq.select { |x, y| x >= 0 && x < grid[0].size && y >= 0 && y < grid.size  }
  visited.size
end

puts "Part 1: #{energy(BeamPos.new(-1, 0, 1, 0), grid)}"

part2 = 0
# Beams coming from left
0.upto(grid.size - 1) {|y| part2 = [part2, energy(BeamPos.new(-1, y, 1, 0), grid)].max }
# Beams coming from right
0.upto(grid.size - 1) {|y| part2 = [part2, energy(BeamPos.new(grid[0].length, y, -1, 0), grid)].max }
# Beams coming from above
0.upto(grid[0].size - 1) {|x| part2 = [part2, energy(BeamPos.new(x, -1, 0, 1), grid)].max }
# Beams coming from below
0.upto(grid[0].size - 1) {|x| part2 = [part2, energy(BeamPos.new(x, grid.size, 0, -1), grid)].max }

puts "Part 2: #{part2}"
