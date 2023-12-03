require 'pry'
LINES = File.readlines('03/input').map(&:strip)

def is_digit?(s)
  code = s.ord
  # 48 is ASCII code of 0
  # 57 is ASCII code of 9
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
    [x - 1, y    ], [x, y    ], [x + 1, y    ],
    [x - 1, y + 1], [x, y + 1], [x + 1, y + 1],
  ].any? { |x, y| is_symbol?(x, y) }
end

Number = Struct.new(:start_x, :start_y, :end_x, :end_y, :xs, :value)
numbers = []

def xs(start_x, end_x)
  (start_x..end_x).to_a
end

LINES.each_with_index do |line, y|
  start_x = nil

  x = 0
  line.chars.each_with_index do |char, x|
    puts "  Char #{char} (#{x},#{y})"
    if start_x
      puts '  Existing number'
      if is_digit?(char)
        puts '    Continue on existing number'
      else
        puts '    End of number'
        numbers << Number.new(start_x, y, x - 1, y, xs(start_x, x-1), line[start_x..x - 1].to_i)
        start_x = nil
      end
    else
      if is_digit?(char)
        puts "  New number:#{char}, #{char.to_i}"
        start_x = x
      else
        puts '  No number'
        start_x = nil
      end
    end
  end

  if start_x
    puts '  Finish this one off'
    numbers << Number.new(start_x, y, line.length - 1, y, xs(start_x, line.length - 1), line[start_x..-1].to_i)
  end
end

puts '*********************'

def near_x?(x, number)
  [x-1, x, x+1].any? { |x| number.xs.include?(x) }
end

gears = []
gear_ratios = 0
LINES.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    if char == '*'
      numbers_above = numbers.select { |n| n.start_y == y - 1 && near_x?(x, n) }
      numbers_left = numbers.select { |n| n.start_y == y && n.end_x == x-1 }
      numbers_right = numbers.select { |n| n.start_y == y && n.start_x == x+1 }
      numbers_below = numbers.select { |n| n.start_y == y + 1 && near_x?(x, n) }

      nearby_numbers = numbers_above + numbers_left + numbers_right + numbers_below
      if nearby_numbers.count == 2
        puts "Found gear at #{x},#{y}"
        gear_ratio = nearby_numbers[0].value * nearby_numbers[1].value
        puts "  Gear ratio: #{gear_ratio}"
        gear_ratios += gear_ratio
      end
    end
  end
end

puts "Part 2: #{gear_ratios}"
