map = File.readlines('20/input').map(&:strip).map(&:chars)

start, destination = nil, nil
map.each_with_index do |row, y|
    row.each_with_index do |col, x|
        if col == 'S'
            start = [x, y]
        elsif col == 'E'
            destination = [x, y]
        end
    end
end

def neighbours(map, pos)
    result = []
    x, y = *pos
    result << [x-1, y] if x > 0
    result << [x+1, y] if x < map[0].count - 1
    result << [x, y-1] if y > 0
    result << [x, y+1] if y < map.count - 1
    result
end

def find_path(map, start, destination)
    positions = Set.new([start])
    seen = Set.new([start])
    result = [start]
    loop do
        raise "No path!" if positions.empty?

        new_positions = Set.new
        positions.each do |pos|
            neighbours(map, pos).each do |n_x, n_y|
                next if map[n_y][n_x] == '#' || seen.include?([n_x, n_y])
                result << [n_x, n_y]
                new_positions << [n_x, n_y]
                seen << [n_x, n_y]
            end
        end
        positions = new_positions
        raise "Too many positions - we expect only a single possible path" if positions.count > 1
        return result if positions.include?(destination)
    end
end

def manhattan_distance(p1, p2)
    (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

def solve(original_path, start_index, end_index)
    cheat_start, cheat_end = original_path[start_index], original_path[end_index]

    would_have_normally_walked = end_index - start_index
    will_now_walk = manhattan_distance(cheat_start, cheat_end)
    would_have_normally_walked - will_now_walk
end

original_path = find_path(map, start, destination)
savings_map = Hash.new(0)

part_1, part_2 = 0, 0
cheat_length = 20
original_path.each_with_index do |cheat_start, start_idx|
    puts start_idx if start_idx % 100 == 0
    (start_idx+1).upto(original_path.count-1) do |end_idx|
        cheat_start, cheat_end = original_path[start_idx], original_path[end_idx]
        distance = manhattan_distance(cheat_start, cheat_end)
        if distance <= 20
            savings = solve(original_path, start_idx, end_idx)
            if savings >= 100
                part_2 += 1
                part_1 += 1 if distance <= 2
            end
        end
    end
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
