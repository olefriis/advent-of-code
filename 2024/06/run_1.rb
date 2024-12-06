require 'pry'
area = File.readlines('06/input').map(&:strip).map(&:chars)

guard_x, guard_y = 0, 0
area.each_with_index do |row, y|
    row.each_with_index do |col, x|
        guard_x, guard_y = x, y if col == '^'
    end
end

visited = Set.new
direction = [0, -1]

while true
    visited << [guard_x, guard_y]
    new_x, new_y = guard_x + direction.first, guard_y + direction.last
    break if new_y < 0 || new_y >= area.count
    break if new_x < 0 || new_x >= area[0].count

    new_char = area[new_y][new_x]
    if new_char == '#'
        # Turn right, don't move
        direction = [-direction.last, direction.first]
    else
        # Move
        guard_x += direction.first
        guard_y += direction.last
        break if guard_y < 0 || guard_y >= area.count
        break if guard_x < 0 || guard_x >= area[0].count
    end
end

puts "Part 1: #{visited.count}"
