lines = File.readlines('04/input').map(&:strip).map(&:chars)

adjacent_positions = [
  [-1, -1], [-1, 0], [-1, 1],
  [0, -1],           [0, 1],
  [1, -1],  [1, 0],  [1, 1]
]

part_1 = 0
lines.each_with_index do |line, y|
  line.each_with_index do |char, x|
    if char != '@'
      print char
    else
      adjacent_paper_rolls = adjacent_positions.filter_map do |dx, dy|
        adjacent_x, adjacent_y = x + dx, y + dy
        next if adjacent_x < 0 || adjacent_y < 0 || adjacent_x >= line.length || adjacent_y >= lines.length

        lines[adjacent_y][adjacent_x] == '@'
      end
      accessible = adjacent_paper_rolls.count
      print(accessible < 4 ? 'x' : '@')
      #print accessible
      #puts "Line: #{line.join} - Adjacent paper rolls: #{adjacent_paper_rolls.count}"
      part_1 += 1 if accessible < 4
    end
  end
  puts ""
end

puts "Part 1: #{part_1}"
