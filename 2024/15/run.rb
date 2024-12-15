def find_hole_leftright(map, x, y, direction_x)
    x += direction_x
    loop do
        return nil if map[y][x] == '#'
        return x if map[y][x] == '.'
        x += direction_x
    end
end

def move_boxes_leftright(map, x, y, direction_x_to_move)
    while map[y][x - direction_x_to_move] != '.'
        map[y][x] = map[y][x - direction_x_to_move]
        map[y][x - direction_x_to_move] = '.'
        x -= direction_x_to_move
    end
end

def find_touching_boxes(map, x, y, direction_y)
    tracked_boxes = [x]
    result = { y => tracked_boxes }

    until tracked_boxes.empty?
        y += direction_y
        tracked_boxes = tracked_boxes.flat_map do |box_x|
            case map[y][box_x]
            when '['
                [box_x, box_x + 1]
            when ']'
                [box_x - 1, box_x]
            when 'O'
                [box_x]
            else
                []
            end
        end.uniq
        result[y] = tracked_boxes
    end

    result
end

def obstacles?(map, boxes, direction_y)
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

def process(map, instructions, robot_x, robot_y)
    instructions.each do |instruction|
        case instruction
        when '<', '>'
            direction = instruction == '>' ? 1 : -1

            hole_to_the_side = find_hole_leftright(map, robot_x, robot_y, direction)
            if hole_to_the_side
                move_boxes_leftright(map, hole_to_the_side, robot_y, direction)
                robot_x += direction
            end
        when 'v', '^'
            direction = instruction == 'v' ? 1 : -1

            touching_boxes = find_touching_boxes(map, robot_x, robot_y, direction)
            unless obstacles?(map, touching_boxes, direction)
                move_boxes_updown(map, touching_boxes, direction)
                robot_y += direction
            end
        else
            raise "Unknown instruction #{instruction}"
        end
    end
end

def score(map)
    map.each_with_index.sum do |row, y|
        row.each_with_index.sum do |col, x|
            ['[', 'O'].include?(col) ? 100 * y + x : 0
        end
    end
end

chunks = File.read('15/input').split("\n\n")
part_1_map = chunks[0].lines.map(&:strip).map(&:chars)
instructions = chunks[1].lines.map(&:strip).join.chars

robot_x, robot_y = 0, 0
part_1_map.each_with_index do |row, y|
    row.each_with_index do |col, x|
        robot_x, robot_y = x, y if col == '@'
    end
end
part_1_map[robot_y][robot_x] = '.'
part_2_map = part_1_map.map do |line|
    line.flat_map do |col|
        {
            '#' => ['#', '#'],
            '.' => ['.', '.'],
            'O' => ['[', ']']
        }[col]
    end
end

process(part_1_map, instructions, robot_x, robot_y)
puts "Part 1: #{score(part_1_map)}"

process(part_2_map, instructions, robot_x * 2, robot_y)
puts "Part 2: #{score(part_2_map)}"
