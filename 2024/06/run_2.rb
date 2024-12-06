require 'pry'
area = File.readlines('06/input').map(&:strip).map(&:chars)

guard_x, guard_y = 0, 0
area.each_with_index do |row, y|
    row.each_with_index do |col, x|
        guard_x, guard_y = x, y if col == '^'
    end
end

def loop?(area, guard_x, guard_y, obstacle_x, obstacle_y)
    visited = Set.new
    direction = [0, -1]
    record = true

    loop do
        #puts "At #{guard_x}, #{guard_y} and direction #{direction}"
        if record && visited.include?([guard_x, guard_y, direction])
            #puts "Coming back to #{guard_x}, #{guard_y} and direction #{direction}"
            return true
        end
        record = true
        visited << [guard_x, guard_y, direction]
        new_x, new_y = guard_x + direction.first, guard_y + direction.last
        return false if new_y < 0 || new_y >= area.count
        return false if new_x < 0 || new_x >= area[0].count
    
        new_char = area[new_y][new_x]
        if new_char == '#' || (new_x == obstacle_x && new_y == obstacle_y)
            #puts "Turning right"
            # Turn right, don't move
            direction = [-direction.last, direction.first]
            record = false
        else
            # Move
            guard_x += direction.first
            guard_y += direction.last
            return false if guard_y < 0 || guard_y >= area.count
            return false if guard_x < 0 || guard_x >= area[0].count
            record = true
        end
    end
    return false
end

part_2 = 0

area.each_with_index do |row, y|
    puts "Row #{y}"
    row.each_with_index do |col, x|
        if col != '#' && loop?(area, guard_x, guard_y, x, y)
            #puts "Works at #{x}, #{y}"
            #binding.pry
            part_2 += 1
        end
    end
end


puts "Part 2: #{part_2}"
