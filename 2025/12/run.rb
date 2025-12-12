lines = File.readlines('12/input').map(&:strip)

# First 30 lines are made up of sections with a number, 3 lines of shapes, and a blank line
shape_blocks = 6.times.map do |i|
  shape_lines = lines[(i * 5 + 1)..(i * 5 + 3)]
  shape_lines.map { |line| line.chars.count('#') }.sum
end

# Lines 31 onward are "problems"
part_1 = lines[30..-1].count do |line|
  parts = line.split(' ')
  dimensions = parts[0][0..-2].split('x').map(&:to_i)
  shape_indices = parts[1..].map(&:to_i)
  area = dimensions[0] * dimensions[1]
  shape_area = shape_indices.each_with_index.map {|count, index| count * shape_blocks[index]}.sum
  shape_area <= area
end
puts "Part 1: #{part_1}"
