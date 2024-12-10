lines = File.readlines('10/input').map(&:strip).map {|line| line.chars.map(&:to_i)}

trailheads = []
lines.each_with_index do |row, y|
    row.each_with_index do |col, x|
        trailheads << [x, y] if col == 0
    end
end

def neighbours(map, x, y)
    result = []
    result << [x-1, y] if x > 0
    result << [x+1, y] if x < map[0].count - 1
    result << [x, y-1] if y > 0
    result << [x, y+1] if y < map.count - 1
    result
end

def score(map, x, y)
    current_positions = Set.new
    current_positions << [x, y]
    current_height = 0

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

part_1 = 0
trailheads.each do |trailhead|
    x, y = *trailhead
    part_1 += score(lines, x, y)
end
puts "Part 1: #{part_1}"

def paths(map, x, y)
    current_value = map[y][x]
    return 1 if current_value == 9

    result = 0
    neighbours(map, x, y).each do |n_x, n_y|
        if map[n_y][n_x] == current_value + 1
            result += paths(map, n_x, n_y)
        end
    end
    result
end
part_2 = 0
trailheads.each do |trailhead|
    x, y = *trailhead
    part_2 += paths(lines, x, y)
end
puts "Part 2: #{part_2}"
