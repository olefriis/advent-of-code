groups = File.read("13/input").split("\n\n").map {|group| group.split("\n").map(&:strip).map(&:chars)}

def transpose(lines)
  result = []
  (lines[0].length).times { result << [] }
  lines.each do |line|
    line.each_with_index do |char, i|
      result[i] << char
    end
  end
  result
end

def solve(lines)
  results = []
  i = 0
  while i < lines.length-1
    upper = lines[0..i].reverse
    lower = lines[i+1..-1]
    to_compare = [upper.length, lower.length].min
    match = true
    0.upto(to_compare-1) do |j|
      if upper[j] != lower[j]
        match = false
      end
    end
    results << i+1 if match
    i += 1
  end
  results
end

def value(lines)
  (solve(transpose(lines)).first || 0) + 100 * (solve(lines).first || 0)
end

def solve_2(lines)
  lines.length.times do |y|
    lines[y].length.times do |x|
      previous_value = lines[y][x]
      if !['.', '#'].include?(previous_value)
        next
      end
      new_value = {'.' => '#', '#' => '.'}[previous_value]
      lines[y][x] = new_value
      solve(lines).each do |result|
        if result > 0
          covered_lines = [result, lines.length - result].min
          if y >= result-covered_lines && y < result + covered_lines
            lines[y][x] = previous_value
            return result
          end
        end
      end
      lines[y][x] = previous_value
    end
  end
  0
end

def value_2(lines)
  v1 = solve_2(transpose(lines))
  v2 = solve_2(lines)
  raise "Too many results" if v1 != 0 && v2 != 0
  raise "No results" if v1 == 0 && v2 == 0
  v1 + 100 * v2
end

puts "Part 1: #{groups.map {|g| value(g)}.sum}"
puts "Part 2: #{groups.map {|g| value_2(g)}.sum}"
