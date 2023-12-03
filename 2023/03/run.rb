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

part1 = 0

LINES.each_with_index do |line, y|
  puts "Line: #{line}"
  current_number = nil
  adjacent_symbol = false

  x = 0
  while x < line.length
    puts "  Char #{x} #{y}: #{line[x]}, current_number: #{current_number}, adjacent_symbol: #{adjacent_symbol}"
    char = line[x]
    if current_number
      puts '  Existing number'
      if is_digit?(char)
        puts '    Continue on existing number'
        # Continue on existing number
        current_number *= 10
        current_number += char.to_i
        adjacent_symbol ||= has_adjacent_symbol?(x, y)
      else
        puts '    End of number'
        # End of number
        if adjacent_symbol
          part1 += current_number
        end
        current_number = nil
        adjacent_symbol = false
      end
    else
      if is_digit?(char)
        puts "  New number:#{char}, #{char.to_i}"
        # New number
        current_number = char.to_i
        adjacent_symbol = has_adjacent_symbol?(x, y)
      else
        puts '  No number'
        # No number before, no number now
        current_number = nil
        adjacent_symbol = false
      end
    end

    x += 1
  end

  if current_number && adjacent_symbol
    puts '  Finish this one off'
    # Finish this one off
    part1 += current_number
  end
end

puts "Part 1: #{part1}"
