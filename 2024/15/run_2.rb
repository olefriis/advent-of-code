chunks = File.read('15/input').split("\n\n")

map = chunks[0].lines.map(&:strip).map(&:chars)
instructions = chunks[1].lines.map(&:strip).join.chars

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

REPLACEMENTS = {
    '#' => ['#', '#'],
    '.' => ['.', '.'],
    'O' => ['[', ']']
}

map = map.map do |line|
    line.flat_map do |col|
        REPLACEMENTS[col]
    end
end
robot_x *= 2

def end_of_boxes_leftright(map, x, y, direction_x)
    x += direction_x
    while ['[', ']'].include?(map[y][x])
        x += direction_x
    end
    if map[y][x] == '#'
        nil
    else
        x
    end
end

def move_boxes_leftright(map, x, y, direction_x_to_move)
    while ['[', ']'].include?(map[y][x])
        map[y][x + direction_x_to_move] = map[y][x]
        map[y][x] = '.'
        x -= direction_x_to_move
    end
end

DIRECTIONS = {
    '^' => [0, -1],
    'v' => [0, 1],
    '<' => [-1, 0],
    '>' => [1, 0]
}

def find_touching_boxes(map, x, y, direction_y)
    current_boxes = Set.new
    current_boxes << x

    result = {}

    loop do
        next_boxes = Set.new
        y += direction_y
        current_boxes.each do |box_x|
            if map[y][box_x] == '['
                next_boxes << box_x
                next_boxes << box_x + 1
            elsif map[y][box_x] == ']'
                next_boxes << box_x
                next_boxes << box_x - 1
            end
        end
        break if next_boxes.empty?

        result[y] = next_boxes
        current_boxes = next_boxes
    end
    result
end

def obstacles(map, boxes, direction_y)
    boxes.keys.each do |y|
        boxes[y].each do |x|
            return true if map[y+direction_y][x] == '#'
        end
    end
    false
end

def move_boxes_updown(map, boxes, direction_y)
    boxes.keys.reverse.each do |y|
        boxes[y].each do |x|
            map[y+direction_y][x] = map[y][x]
            map[y][x] = '.'
        end
    end
end

instructions.each do |instruction|
    #puts instruction
    #debug(map, robot_x, robot_y)
    if instruction == '<'
        if map[robot_y][robot_x-1] == '.'
            robot_x -= 1
        else
            end_of_boxes_x = end_of_boxes_leftright(map, robot_x - 1, robot_y, -1)
            if end_of_boxes_x
                move_boxes_leftright(map, end_of_boxes_x+1, robot_y, -1)

                robot_x -= 1
            end
        end
    elsif instruction == '>'
        if map[robot_y][robot_x+1] == '.'
            robot_x += 1
        else
            end_of_boxes_x = end_of_boxes_leftright(map, robot_x, robot_y, 1)
            if end_of_boxes_x
                move_boxes_leftright(map, end_of_boxes_x-1, robot_y, 1)

                robot_x += 1
            end
        end
    elsif instruction == 'v'
        if map[robot_y+1][robot_x] != '#'
            boxes = find_touching_boxes(map, robot_x, robot_y, 1)
            if !obstacles(map, boxes, 1)
                move_boxes_updown(map, boxes, 1)
                robot_y += 1
            end
        end
    elsif instruction == '^'
        if map[robot_y-1][robot_x] != '#'
            boxes = find_touching_boxes(map, robot_x, robot_y, -1)
            if !obstacles(map, boxes, -1)
                move_boxes_updown(map, boxes, -1)
                robot_y -= 1
            end
        end
    else
        raise "Unknown instruction #{instruction}"
    end
end

part_2 = 0
map.each_with_index do |row, y|
    row.each_with_index do |col, x|
        part_2 += 100 * y + x if col == '['
    end
end
puts "Part 2: #{part_2}"
