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

def find_path(map, start, destination)
    coming_from = start
    path = [start]
    position = start
    until position == destination do
        x, y = *position
        neighbours = [
            [x-1, y],
            [x+1, y],
            [x, y-1],
            [x, y+1]
        ]
        possibilities = (neighbours - [coming_from]).select { |x, y| map[y][x] != '#' }
        raise "More than one possibility!" if possibilities.count > 1
        coming_from = position
        position = possibilities[0]
        path << position
    end
    path
end

def manhattan_distance(p1, p2)
    (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

def solve(original_path, start_index, end_index)
    cheat_start, cheat_end = original_path[start_index], original_path[end_index]

    end_index - start_index - manhattan_distance(cheat_start, cheat_end)
end

original_path = find_path(map, start, destination)
savings_map = Hash.new(0)

part_1, part_2 = 0, 0
original_path.each_with_index do |cheat_start, start_idx|
    puts start_idx if start_idx % 100 == 0
    (start_idx+1).upto(original_path.count-1) do |end_idx|
        cheat_start, cheat_end = original_path[start_idx], original_path[end_idx]
        distance = manhattan_distance(cheat_start, cheat_end)
        savings = solve(original_path, start_idx, end_idx)
        part_1 += 1 if distance <= 2 && savings >= 100
        part_2 += 1 if distance <= 20 && savings >= 100
    end
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
