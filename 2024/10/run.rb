map = File.readlines('10/input').map(&:strip).map {|line| line.chars.map(&:to_i)}

def neighbours(map, x, y)
    result = []
    result << [x-1, y] if x > 0
    result << [x+1, y] if x < map[0].count - 1
    result << [x, y-1] if y > 0
    result << [x, y+1] if y < map.count - 1
    result
end

def part_1_score(map, x, y)
    current_positions = Set.new
    current_positions << [x, y]

    1.upto(9) do |new_height|
        new_positions = Set.new
        current_positions.each do |x, y|
            neighbours(map, x, y).each do |n_x, n_y|
                new_positions << [n_x, n_y] if map[n_y][n_x] == new_height
            end
        end
        current_positions = new_positions
    end

    current_positions.count
end

def part_2_score(map, x, y)
    current_value = map[y][x]
    return 1 if current_value == 9

    neighbours(map, x, y).sum do |n_x, n_y|
        map[n_y][n_x] == current_value + 1 ? part_2_score(map, n_x, n_y) : 0
    end
end

part_1, part_2 = 0, 0
map.each_with_index do |row, y|
    row.each_with_index do |col, x|
        if col == 0
            part_1 += part_1_score(map, x, y)
            part_2 += part_2_score(map, x, y)
        end
    end
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
