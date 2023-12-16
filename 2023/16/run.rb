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

      next_x, next_y = pos.x + pos.dx, pos.y + pos.dy
      next if next_x < 0 || next_x >= grid[0].size || next_y < 0 || next_y >= grid.size

      case grid[next_y][next_x]
      when '.'
        new_edge << BeamPos.new(next_x, next_y, pos.dx, pos.dy)
      when '-'
        if pos.dx == 0
          new_edge << BeamPos.new(next_x, next_y, 1, 0)
          new_edge << BeamPos.new(next_x, next_y, -1, 0)
        else
          new_edge << BeamPos.new(next_x, next_y, pos.dx, pos.dy)
        end
      when '|'
        if pos.dy == 0
          new_edge << BeamPos.new(next_x, next_y, 0, 1)
          new_edge << BeamPos.new(next_x, next_y, 0, -1)
        else
          new_edge << BeamPos.new(next_x, next_y, pos.dx, pos.dy)
        end
      when '/'
        case [pos.dx, pos.dy]
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
      when '\\'
        case [pos.dx, pos.dy]
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
      else
        raise "Impossible"
      end
    end

    edge = new_edge
  end

  seen.map { |pos| [pos.x, pos.y] }.uniq.select { |x, y| x >= 0 && x < grid[0].size && y >= 0 && y < grid.size  }.size
end

puts "Part 1: #{energy(BeamPos.new(-1, 0, 1, 0), grid)}"

all_energy_levels = grid.size.times.map {|y| energy(BeamPos.new(-1, y, 1, 0), grid) } + # Beams coming from left
                    grid.size.times.map {|y| energy(BeamPos.new(grid[0].length, y, -1, 0), grid) } + # Beams coming from right
                    grid[0].size.times.map {|x| energy(BeamPos.new(x, -1, 0, 1), grid) } + # Beams coming from above
                    grid[0].size.times.map {|x| energy(BeamPos.new(x, grid.size, 0, -1), grid) } # Beams coming from below
puts "Part 2: #{all_energy_levels.max}"
