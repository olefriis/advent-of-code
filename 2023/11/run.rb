lines = File.readlines('11/input').map(&:strip).map(&:chars)

blank_columns = (0...lines[0].length).to_a
blank_rows = []

galaxies = []
lines.each_with_index do |line, y|
  if line.all?('.')
    blank_rows << y
  else
    line.each_with_index do |char, x|
      if char == '#'
        galaxies << [x, y]
        blank_columns.delete(x)
      end
    end
  end
end

def distances(galaxies, blank_rows, blank_columns, multiplier)
  moved_galaxies = galaxies.map do |x, y|
    empty_above = blank_rows.select { |row| row < y }
    empty_to_the_left = blank_columns.select { |col| col < x }
    [x + multiplier * empty_to_the_left.length, y + multiplier * empty_above.length]
  end
  
  result = 0
  moved_galaxies.each_with_index do |g1, i|
    moved_galaxies[i + 1..-1].each do |g2|
      result += (g1[0] - g2[0]).abs + (g1[1] - g2[1]).abs
    end
  end
  result
end

puts "Part 1: #{distances(galaxies, blank_rows, blank_columns, 1)}"
puts "Part 2: #{distances(galaxies, blank_rows, blank_columns, 1000000-1)}"
