coordinates = File.readlines('18/input').map(&:strip).map { |line| line.split(',').map(&:to_i) }

WIDTH = 71
HEIGHT = 71

def neighbours(x, y)
    result = []
    result << [x-1, y] if x > 0
    result << [x+1, y] if x < WIDTH - 1
    result << [x, y-1] if y > 0
    result << [x, y+1] if y < HEIGHT - 1
    result
end

def solve(map)
    positions = Set.new
    positions << [0, 0]
    iterations = 0
    seen = Set.new
    until positions.empty?
        new_positions = Set.new
        positions.each do |x, y|
            neighbours(x, y).each do |n_x, n_y|
                next if map[[n_x, n_y]] || seen.include?([n_x, n_y])
                new_positions << [n_x, n_y]
                seen << [n_x, n_y]
            end
        end
        positions = new_positions
        iterations += 1
        return iterations if positions.include?([HEIGHT-1, WIDTH-1])
    end
    
    nil
end

map = {}
coordinates[0...1024].each do |x, y|
    map[[x, y]] = true
end
puts "Part 1: #{solve(map)}"

part_2 = coordinates[1024..].find do |x, y|
    map[[x, y]] = true
    !solve(map)
end
puts "Part 2: #{part_2[0]},#{part_2[1]}"
