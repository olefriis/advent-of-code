map = File.readlines('12/input').map(&:strip).map(&:chars)

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

def number_of_sides_in_direction(region, direction)
    # Start by "throwing fences" in the direction given. Avoid putting fences on top of the region itself.
    fences = region.map { |x, y| [neighbour_x = x + direction[0], neighbour_y = y + direction[1]] } - region.to_a

    # Then count the number of uninterrupted line segments this gives. We do this by counting "endings" of the
    # fence segments, i.e., those cells that do not have a neighbour that is also a fence cell.
    fences.count { |x, y| !fences.include?([x - direction[1], y + direction[0]]) }
end

def find_sides_for_region(map, region)
    [
        [0, 1],
        [0, -1],
        [-1, 0],
        [1, 0]
    ].sum { |direction| number_of_sides_in_direction(region, direction) }
end

handled = Set.new
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
