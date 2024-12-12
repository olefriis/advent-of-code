map = File.readlines('12/input').map(&:strip).map(&:chars)

handled = Set.new

def neighbours(map, x, y)
    result = []
    result << [x-1, y] if x > 0
    result << [x+1, y] if x < map[0].count - 1
    result << [x, y-1] if y > 0
    result << [x, y+1] if y < map.count - 1
    result
end

def find_region(map, x, y)
    type = map[y][x]
    region = Set.new
    region << [x, y]
    edge = [[x, y]]

    while !edge.empty?
        new_edge = []
        edge.each do |new_x, new_y|

            neighbours(map, new_x, new_y).each do |n_x, n_y|
                next if region.include?([n_x, n_y])
                if map[n_y][n_x] == type
                    region << [n_x, n_y] 
                    new_edge << [n_x, n_y] 
                end
            end
        end
        edge = new_edge
    end

    region
end

def find_perimeter(map, region)
    result = 0
    region.each do |x, y|
        result += 1 if x == 0 || !region.include?([x-1, y])
        result += 1 if x == map[0].count-1 || !region.include?([x+1, y])

        result += 1 if y == 0 || !region.include?([x, y-1])
        result += 1 if y == map.count-1 || !region.include?([x, y+1])
    end
    result
end

def eliminate_side(fences, position, direction)
    fences.delete(position)

    # Go in one direction first
    new_position = [position[0] + direction[0], position[1] + direction[1]]
    while fences.include?(new_position)
        fences.delete(new_position)
        new_position = [new_position[0] + direction[0], new_position[1] + direction[1]]
    end

    # Then the other direction
    new_position = [position[0] - direction[0], position[1] - direction[1]]
    while fences.include?(new_position)
        fences.delete(new_position)
        new_position = [new_position[0] - direction[0], new_position[1] - direction[1]]
    end
end

def sides(region, direction)
    marked = Set.new
    region.each do |x, y|
        neighbour_x = x + direction[0]
        neighbour_y = y + direction[1]

        marked << [neighbour_x, neighbour_y] unless region.include?([neighbour_x, neighbour_y])
    end
    
    result = 0
    orthogonal_direction = [-direction[1], direction[0]]
    while !marked.empty?
        position = marked.first
        result += 1
        eliminate_side(marked, position, orthogonal_direction)
    end
    result
end

def find_sides_for_region(map, region)
    horizontal_below_positions = sides(region, [0, 1])
    horizontal_above_positions = sides(region, [0, -1])

    vertical_left_of_positions = sides(region, [-1, 0])
    vertical_right_of_positions = sides(region, [1, 0])

    horizontal_below_positions + horizontal_above_positions + vertical_left_of_positions + vertical_right_of_positions
end

part_1, part_2 = 0, 0
map.each_with_index do |row, y|
    row.each_with_index do |col, x|
        if !handled.include?([x, y])
            region = find_region(map, x, y)
            perimeter = find_perimeter(map, region)
            sides = find_sides_for_region(map, region)
            region.each {|p| handled << p}

            part_1 += region.count * perimeter
            part_2 += region.count * sides
        end
    end
end
puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
