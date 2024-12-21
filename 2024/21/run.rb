codes = File.readlines('21/input').map(&:strip)

NUMERIC_LAYOUT = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    [nil, '0', 'A']
]
DIRECTIONAL_LAYOUT = [
    [nil, '^', 'A'],
    ['<', 'v', '>']
]

def position_for(layout, char)
    layout.each_with_index do |row, y|
        row.each_with_index do |col, x|
            return [x, y] if col == char
        end
    end
    raise "#{char} not in #{layout}"
end

def valid?(layout, x, y, directions)
    directions.each do |direction|
        x += 1 if direction == '>'
        x -= 1 if direction == '<'
        y += 1 if direction == 'v'
        y -= 1 if direction == '^'
        return false if layout[y][x].nil?
    end
    true
end

def combinations(from, to, layout)
    x, y = *position_for(layout, from)
    destination_x, destination_y = *position_for(layout, to)

    moves = [
        *(['>'] * [0, destination_x - x].max),
        *(['<'] * [0, x - destination_x].max),
        *(['v'] * [0, destination_y - y].max),
        *(['^'] * [0, y - destination_y].max)
    ]

    [moves + ['A'], moves.reverse + ['A']].select { |m| valid?(layout, x, y, m) }
end

COST_CACHE = {}

def cost(from, to, layout, layers)
    COST_CACHE[layers] ||= {}
    existing_result = COST_CACHE[layers][[from, to, layout]]
    return existing_result if existing_result

    if layers == 0
        combinations(from, to, DIRECTIONAL_LAYOUT).map(&:length).min
    else
        result = combinations(from, to, layout).map do |seq|
            (['A'] + seq).each_cons(2).map do |step_from, step_to|
                cost(step_from, step_to, DIRECTIONAL_LAYOUT, layers-1)
            end.sum
        end.min
        COST_CACHE[layers][[from, to, layout]] = result
    end
end

def solve(code, layers)
    code = 'A' + code # We always start at button A

    code.chars.each_cons(2).map do |from, to|
        cost(from, to, NUMERIC_LAYOUT, layers)
    end.sum
end

part_1, part_2 = 0, 0
codes.each do |code|
    part_1 += code[0..3].to_i * solve(code, 2)
    part_2 += code[0..3].to_i * solve(code, 25)
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"

