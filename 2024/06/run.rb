area = File.readlines('06/input').map(&:strip).map(&:chars)

start_x, start_y = 0, 0
area.each_with_index do |row, y|
    row.each_with_index do |col, x|
        start_x, start_y = x, y if col == '^'
    end
end

# Part 1
visited = Set.new
direction = [0, -1]
guard_x, guard_y = start_x, start_y
while true
    visited << [guard_x, guard_y]
    new_x, new_y = guard_x + direction.first, guard_y + direction.last
    break if new_y < 0 || new_y >= area.count
    break if new_x < 0 || new_x >= area[0].count

    new_char = area[new_y][new_x]
    if new_char == '#'
        # Turn
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

def loop?(area, guard_x, guard_y)
    visited = Set.new
    direction = [0, -1]
    moved = true

    loop do
        if moved && visited.include?([guard_x, guard_y, direction])
            return true
        end
        visited << [guard_x, guard_y, direction]
        new_x, new_y = guard_x + direction.first, guard_y + direction.last
        return false if new_y < 0 || new_y >= area.count
        return false if new_x < 0 || new_x >= area[0].count
    
        new_char = area[new_y][new_x]
        if new_char == '#'
            # Turn
            direction = [-direction.last, direction.first]
            moved = false
        else
            # Move
            guard_x += direction.first
            guard_y += direction.last
            return false if guard_y < 0 || guard_y >= area.count
            return false if guard_x < 0 || guard_x >= area[0].count
            moved = true
        end
    end
    return false
end

part_2 = 0
(visited - [start_x, start_y]).each do |x, y|
    area[y][x] = '#'
    part_2 += 1 if loop?(area, start_x, start_y)
    area[y][x] = '.'
end
puts "Part 2: #{part_2}"
