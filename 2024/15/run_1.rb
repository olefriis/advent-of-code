chunks = File.read('15/input').split("\n\n")

map = chunks[0].lines.map(&:strip).map(&:chars)
instructions = chunks[1].lines.map(&:strip).join.chars

def first_hole(map, x, y, direction_x, direction_y)
    x += direction_x
    y += direction_y
    while map[y][x] != '#' && map[y][x] != '.'
        x += direction_x
        y += direction_y
    end
    if map[y][x] == '#'
        nil
    else
        [x, y]
    end
end

def move_boxes(map, x, y, direction_x, direction_y)
    while map[y - direction_y][x - direction_x] == 'O'
        map[y][x] = 'O'
        map[y - direction_y][x - direction_x] = '.'
        x -= direction_x
        y -= direction_y
    end
end

DIRECTIONS = {
    '^' => [0, -1],
    'v' => [0, 1],
    '<' => [-1, 0],
    '>' => [1, 0]
}

def debug(map, robot_x, robot_y)
    map.each_with_index do |row, y|
        line = ''
        row.each_with_index do |col, x|
            line << (robot_x == x && robot_y == y ? '@' : col)
        end
        puts line
    end
    p [robot_x, robot_y]
    puts ''
    puts ''
end    

robot_x, robot_y = 0, 0
map.each_with_index do |row, y|
    row.each_with_index do |col, x|
        robot_x, robot_y = x, y if col == '@'
    end
end
map[robot_y][robot_x] = '.'

instructions.each do |instruction|
    direction = DIRECTIONS[instruction] or raise "No direction for #{instruction}"
    p instruction
    debug(map, robot_x, robot_y)

    hole = first_hole(map, robot_x, robot_y, direction[0], direction[1])
    if hole
        move_boxes(map, hole[0], hole[1], direction[0], direction[1])
        robot_x += direction[0]
        robot_y += direction[1]
    end
end
debug(map, robot_x, robot_y)

part_1 = 0
map.each_with_index do |row, y|
    row.each_with_index do |col, x|
        part_1 += 100 * y + x if col == 'O'
    end
end
puts "Part 1: #{part_1}"
