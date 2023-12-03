LINES = File.readlines('03/input').map(&:strip)

def is_digit?(s)
  code = s.ord
  48 <= code && code <= 57
end

def is_symbol?(x, y)
  return false if x < 0 || y < 0
  return false if x >= LINES[0].length || y >= LINES.length
  char = LINES[y][x]
  !is_digit?(char) && char != '.'
end

def has_adjacent_symbol?(x, y)
  [
    [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
    [x - 1, y    ],             [x + 1, y    ],
    [x - 1, y + 1], [x, y + 1], [x + 1, y + 1],
  ].any? { |x, y| is_symbol?(x, y) }
end

def near_x?(x, number)
  [x-1, x, x+1].any? { |x| number.xs.include?(x) }
end

Number = Struct.new(:y, :xs, :value)
numbers = []

LINES.each_with_index do |line, y|
  line.scan(/\d+/) do |number|
    start_x, end_x_plus_1 = $~.offset(0)
    numbers << Number.new(y, (start_x...end_x_plus_1).to_a, number.to_i)
  end
end

numbers_adjacent_to_symbols = numbers.select do |number|
  number.xs.any? { |x| has_adjacent_symbol?(x, number.y) }
end
puts "Part 1: #{numbers_adjacent_to_symbols.map(&:value).sum}"

gear_ratios = 0
LINES.each_with_index do |line, y|
  line.scan(/\*/) do |star|
    x = $~.offset(0).first
    nearby_numbers = numbers.select { |n| n.y >= y - 1 && n.y <= y+1 && near_x?(x, n) }
    gear_ratios += nearby_numbers.map(&:value).inject(&:*) if nearby_numbers.count == 2
  end
end
puts "Part 2: #{gear_ratios}"
