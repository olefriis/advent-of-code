coordinates = File.readlines('18/input').map(&:strip)

WIDTH = 7
HEIGHT = 7

WIDTH = 71
HEIGHT = 71
map = {}

coordinates[0...1024].each do |coordinate|
    x, y = coordinate.split(',').map(&:to_i)
    map[[x, y]] = true
end

def debug(map)
    HEIGHT.times do |y|
        line = ''
        WIDTH.times do |x|
            if map[[x, y]]
                line << '#'
            else
                line << '.'
            end
        end
        puts line
    end
end


def neighbours(x, y)
    result = []
    result << [x-1, y] if x > 0
    result << [x+1, y] if x < WIDTH - 1
    result << [x, y-1] if y > 0
    result << [x, y+1] if y < HEIGHT - 1
    result
end

debug(map)

def solvable?(map)
    positions = Set.new
    positions << [0, 0]
    iterations = 0
    seen = Set.new
    while !positions.empty? && !positions.include?([HEIGHT-1, WIDTH-1])
        #puts "Iteration #{iterations}: #{positions}"
        new_positions = Set.new
        positions.each do |x, y|
            neighbours(x, y).each do |n_x, n_y|
                next if map[[n_x, n_y]]
                new_positions << [n_x, n_y] unless seen.include?([n_x, n_y])
                seen << [n_x, n_y]
            end
        end
        positions = new_positions
        iterations += 1
    end
    
    if positions.empty?
        return false
    else
        puts "Done in #{iterations} steps"
        return true
    end
end

positions = Set.new
positions << [0, 0]
iterations = 0
seen = Set.new
while !positions.include?([HEIGHT-1, WIDTH-1])
    #puts "Iteration #{iterations}: #{positions}"
    new_positions = Set.new
    positions.each do |x, y|
        neighbours(x, y).each do |n_x, n_y|
            next if map[[n_x, n_y]]
            new_positions << [n_x, n_y] unless seen.include?([n_x, n_y])
            seen << [n_x, n_y]
        end
    end
    positions = new_positions
    iterations += 1
end

puts "Part 1: #{iterations}"

coordinates.each do |coordinate|
    x, y = coordinate.split(',').map(&:to_i)
    map[[x, y]] = true
    if !solvable?(map)
        puts "Part 2: #{x},#{y}"
        break
    end
end
