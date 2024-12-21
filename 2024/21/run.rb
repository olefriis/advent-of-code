codes = File.readlines('21/input').map(&:strip)

LAYOUT_1 = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    [nil, '0', 'A']
]
LAYOUT_2 = [
    [nil, '^', 'A'],
    ['<', 'v', '>']
]

def position_for(layout, char)
    layout.each_with_index do |row, y|
        row.each_with_index do |col, x|
            return [x, y] if col == char
        end
    end
    raise 'Not here!'
end

def solve_directional_pad(code)
    raise 'Does not end with A' unless code.end_with?('A')
    p2_x, p2_y = 2, 0

    resulting_options = ['']

    code.chars.each do |char|
        p2_destination_x, p2_destination_y = *position_for(LAYOUT_2, char)
        p2_diff_x = p2_destination_x - p2_x
        p2_diff_y = p2_destination_y - p2_y
        possibilities_for_2 = []

        vertical_direction = p2_diff_y > 0 ? 'v' : '^'
        horizontal_direction = p2_diff_x > 0 ? '>' : '<'
        options = []

        # Let's try vertical first
        if LAYOUT_2[p2_destination_y][p2_x] != nil
            options << "#{vertical_direction * p2_diff_y.abs}#{horizontal_direction * p2_diff_x.abs}A"
        end
        # Then try horizontal
        if LAYOUT_1[p2_y][p2_destination_x] != nil
            options << "#{horizontal_direction * p2_diff_x.abs}#{vertical_direction * p2_diff_y.abs}A"
        end
        resulting_options = resulting_options.flat_map do |previous_option|
            options.flat_map { |additional_option| previous_option + additional_option }
        end.uniq

        p2_x, p2_y = p2_destination_x, p2_destination_y
    end

    raise 'Ending at wrong position' unless p2_x == 2 && p2_y == 0
    length = resulting_options.first.length
    raise "Hey, different lengths!" if resulting_options.any? {|op| op.length != length}

    resulting_options.first
end

def solve_numeric_pad(code)
    p1_x, p1_y = 2, 3
    directional_possibilities = ['']

    code.chars.each do |char|
        p1_destination_x, p1_destination_y = *position_for(LAYOUT_1, char)
        p1_diff_x = p1_destination_x - p1_x
        p1_diff_y = p1_destination_y - p1_y
    
        # We can begin by going vertical or horizontal, but we should not interleave them
        possibilities_for_1 = []
        vertical_direction = p1_diff_y > 0 ? 'v' : '^'
        horizontal_direction = p1_diff_x > 0 ? '>' : '<'
        # Let's try vertical first
        if LAYOUT_1[p1_destination_y][p1_x] != nil
            possibilities_for_1 << "#{vertical_direction * p1_diff_y.abs}#{horizontal_direction * p1_diff_x.abs}A"
        end
        # Then try horizontal
        if LAYOUT_1[p1_y][p1_destination_x] != nil
            possibilities_for_1 << "#{horizontal_direction * p1_diff_x.abs}#{vertical_direction * p1_diff_y.abs}A"
        end

        directional_possibilities = directional_possibilities.flat_map do |old_possibility|
            possibilities_for_1.map { |p| old_possibility + p }
        end.uniq

        p1_x, p1_y = p1_destination_x, p1_destination_y
    end

    # We should end up at 2, 3
    raise 'Invalid end position' unless p1_x == 2 && p1_y == 3
    directional_possibilities
end

def split(code)
    raise 'Something is wrong' unless code.end_with?('A')
    start, result = 0, []
    0.upto(code.length-1) do |i|
        if code[i] == 'A'
            result << code[start..i]
            start = i+1
        end
    end
    result
end

def solve(code, layers)
    directional_possibilities = solve_numeric_pad(code)
    outer_possibilities = directional_possibilities.map do |possibility|
        result = Hash.new(0)
        split(possibility).each { |code| result[code] += 1 }
        result
    end
    first_outer_possibilities = outer_possibilities
    layers.times do
        outer_possibilities = outer_possibilities.flat_map do |possibility|
            result = Hash.new(0)
            possibility.map do |code, times|
                split(solve_directional_pad(code)).each { |code| result[code] += times }
            end
            result
        end.uniq
    end

    outer_possibilities.map do |possibility|
        possibility.map {|code, times| code.length * times}.sum
    end.min
end

part_1, part_2 = 0, 0
codes.each do |code|
    part_1 += code[0..3].to_i * solve(code, 2)
    part_2 += code[0..3].to_i * solve(code, 26)
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
