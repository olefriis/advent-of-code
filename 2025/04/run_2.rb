lines = File.readlines('04/input').map(&:strip).map(&:chars)

adjacent_positions = [
  [-1, -1], [-1, 0], [-1, 1],
  [0, -1],           [0, 1],
  [1, -1],  [1, 0],  [1, 1]
]

part_2 = 0
removed = 1
while removed > 0
  removed = 0
  lines.each_with_index do |line, y|
    line.each_with_index do |char, x|
      if char != '@'
        #print char
      else
        adjacent_paper_rolls = adjacent_positions.filter_map do |dx, dy|
          adjacent_x, adjacent_y = x + dx, y + dy
          next if adjacent_x < 0 || adjacent_y < 0 || adjacent_x >= line.length || adjacent_y >= lines.length

          lines[adjacent_y][adjacent_x] == '@'
        end
        accessible = adjacent_paper_rolls.count
        if accessible < 4
          lines[y][x] = ' '
          part_2 += 1
          removed += 1
        end
      end
    end
  end
  puts "Removed #{removed} paper rolls"
end

puts "Part 2: #{part_2}"
