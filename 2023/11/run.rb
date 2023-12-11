lines = File.readlines('11/input').map(&:strip).map(&:chars)

blank_columns = (0...lines[0].length).to_a
blank_rows = []
galaxies = []

lines.each_with_index do |line, y|
  blank_rows << y if line.all?('.')

  line.each_with_index.select {|char, x| char == '#'}.each do |char, x|
    galaxies << [x, y]
    blank_columns.delete(x)
  end
end

def distances(galaxies, blank_rows, blank_columns, blank_space_size)
  moved_galaxies = galaxies.map do |x, y|
    blank_above = blank_rows.count {|row| row < y}
    blank_to_the_left = blank_columns.count {|col| col < x}
    [x + (blank_space_size-1) * blank_to_the_left, y + (blank_space_size-1) * blank_above]
  end
  
  moved_galaxies.each_with_index.map do |g1, i|
    moved_galaxies[i + 1..-1].map do |g2|
      (g1[0] - g2[0]).abs + (g1[1] - g2[1]).abs
    end.sum
  end.sum
end

puts "Part 1: #{distances(galaxies, blank_rows, blank_columns, 2)}"
puts "Part 2: #{distances(galaxies, blank_rows, blank_columns, 1000000)}"
