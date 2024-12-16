map = File.readlines('16/input').map(&:strip).map(&:chars)

r_x, r_y, e_x, e_y = 0, 0, 0, 0
map.each_with_index do |row, y|
    row.each_with_index do |col, x|
        r_x, r_y = x, y if col == 'S'
        e_x, e_y = x, y if col == 'E'
    end
end

EAST = [1, 0]

require 'pry'
def calculate_part_2(map, positions, coming_from, part_1)
    parts_of_good_path = Set.new

    positions.each do |position|
        parts_of_good_path << position[0]
        last_positions = Set.new
        last_positions << position
        i = part_1
        while i > 0
            i -= 1
            new_last_positions = Set.new
    
            last_positions.each do |pos|
                was_here = coming_from[i][pos]
                was_here.each do |was_pos|
                    new_last_positions << was_pos
                    parts_of_good_path << was_pos[0]
                end
            end
    
            last_positions = new_last_positions
        end
    end

    #debug(map, parts_of_good_path)

    puts "Part 2: #{parts_of_good_path.count}"
end

def debug(map, good_path)
    map.each_with_index do |row, y|
        line = ''
        row.each_with_index do |col, x|
            if good_path.include?([x, y])
                line << 'O'
            else
                line << map[y][x]
            end
        end
        puts line
    end
end

coming_from = {}
seen = Set.new
has_rotated_here = Set.new
part_1 = 0
edge = Set.new
edge << [[r_x, r_y], 0, EAST]
has_rotated_here = Set.new
part_1_solutions = []
until edge.empty?
    puts part_1
    new_edge = Set.new
    new_rotations = Set.new

    edge.each do |previous|
        pos, wait, direction = *previous
        if wait == 0 && pos[0] == e_x && pos[1] == e_y
            part_1_solutions << previous
            coming_from[part_1][previous] ||= Set.new
            coming_from[part_1][previous] << previous
        end

        coming_from[part_1] ||= {}

        if wait > 0
            new_position = [pos, wait - 1, direction]
            new_edge << new_position
            coming_from[part_1][new_position] ||= Set.new
            coming_from[part_1][new_position] << previous
        else
            # Try to rotate in either direction
            rotated_left = [direction[1], -direction[0]]
            rotated_right = [-direction[1], direction[0]]

            if !has_rotated_here.include?([pos, direction, rotated_left])
                new_rotations << [pos, direction, rotated_left]
                new_position = [pos, 999, rotated_left]
                if !seen.include?(new_position)
                    new_edge << new_position
                    coming_from[part_1][new_position] ||= Set.new
                    coming_from[part_1][new_position] << previous
                    seen << new_position
                end
            end
            if !has_rotated_here.include?([pos, direction, rotated_right])
                new_rotations << [pos, direction, rotated_right]
                new_position = [pos, 999, rotated_right]
                if !seen.include?(new_position)
                    new_edge << new_position
                    coming_from[part_1][new_position] ||= Set.new
                    coming_from[part_1][new_position] << previous
                    seen << new_position
                end
            end

            # Try to walk
            new_x, new_y = pos[0] + direction[0], pos[1] + direction[1]
            new_position = [[new_x, new_y], 0, direction]
            if map[new_y][new_x] != '#' && !seen.include?(new_position)
                new_edge << new_position
                coming_from[part_1][new_position] ||= Set.new
                coming_from[part_1][new_position] << previous
                seen << new_position
            end
        end
    end

    if !part_1_solutions.empty?
        puts "Part 1: #{part_1}"
        calculate_part_2(map, part_1_solutions, coming_from, part_1)
        exit
    end

    new_rotations.each do |e|
        has_rotated_here << e
    end

    edge = new_edge
    part_1 += 1
end

puts "Part 1: #{part_1}"
