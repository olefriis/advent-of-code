lines = File.readlines('04/input').map(&:strip).map(&:chars)

def count_and_remove(lines)
  adjacent_positions = [
    [-1, -1], [-1, 0], [-1, 1],
    [0, -1],           [0, 1],
    [1, -1],  [1, 0],  [1, 1]
  ]
  removed = 0
  new_map = lines.each_with_index.map do |line, y|
    line.each_with_index.map do |char, x|
      if char == '@'
        adjacent_rolls = adjacent_positions.map {|dx, dy| [x + dx, y + dy]}.count do |adjacent_x, adjacent_y|
          adjacent_x >= 0 && adjacent_y >= 0 && adjacent_x < line.length && adjacent_y < lines.length && lines[adjacent_y][adjacent_x] == '@'
        end

        if adjacent_rolls < 4
          removed += 1
          '.'
        else
          char
        end
      else
        char
      end
    end
  end
  [removed, new_map]
end

part_1, part_2 = nil, 0
removed = 1 # (Uh, hacky!)
while removed > 0
  removed, lines = count_and_remove(lines)
  part_1 ||= removed
  part_2 += removed
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
