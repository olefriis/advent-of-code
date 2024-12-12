map = File.readlines('12/input').map(&:strip).map(&:chars)

DIRECTIONS = [
    [0, 1],
    [0, -1],
    [-1, 0],
    [1, 0]
]

def find_region(map, x, y)
    type, region, edge = map[y][x], Set.new([[x, y]]), [[x, y]]

    while !edge.empty?
        new_edge = []
        edge.each do |new_x, new_y|
            neighbours = DIRECTIONS.map {|d_x, d_y| [new_x + d_x, new_y + d_y] }.select do |n_x, n_y|
                n_x >= 0 && n_x < map[0].count && n_y >= 0 && n_y < map.count
            end

            neighbours.each do |n_x, n_y|
                next if region.include?([n_x, n_y])
                next unless map[n_y][n_x] == type

                region << [n_x, n_y] 
                new_edge << [n_x, n_y] 
            end
        end
        edge = new_edge
    end

    region
end

def perimeter(map, region)
    DIRECTIONS.sum do |direction|
        # "Shift" the region one step in the given direction, then subtract the region from that.
        # This will give all neighbouring cells to the region, so just count those.
        (region.map { |x, y| [x + direction[0], y + direction[1]] }.uniq - region.to_a).count
    end
end

def sides(map, region)
    DIRECTIONS.sum do |direction|
        # Start by "throwing fences" in the direction given. Avoid putting fences on top of the region itself.
        fences = region.map { |x, y| [x + direction[0], y + direction[1]] } - region.to_a

        # Then count the number of uninterrupted line segments this gives. We do this by counting "endings" of the
        # fence segments, i.e., those cells that do not have a neighbour that is also a fence cell.
        fences.count { |x, y| !fences.include?([x - direction[1], y + direction[0]]) }
    end
end

handled, part_1, part_2 = Set.new, 0, 0
map.count.times do |y|
    map[0].count.times do |x|
        next if handled.include?([x, y])

        region = find_region(map, x, y)
        part_1 += region.count * perimeter(map, region)
        part_2 += region.count * sides(map, region)

        # Ensure we won't handle more cells from the region we just looked at
        region.each { |p| handled << p }
    end
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
