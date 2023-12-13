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

def solve_2(lines)
  old_solutions = solve(lines)
  lines.length.times do |y|
    lines[y].length.times do |x|
      previous_value = lines[y][x]
      next unless ['.', '#'].include?(previous_value)
      new_value = {'.' => '#', '#' => '.'}[previous_value]
      lines[y][x] = new_value
      new_solutions = solve(lines) - old_solutions
      lines[y][x] = previous_value

      return new_solutions[0] if new_solutions.length > 0
    end
  end
  0
end

def value(lines)
  solve(transpose(lines)).fetch(0, 0) + 100 * (solve(lines).fetch(0, 0))
end

def value_2(lines)
  solve_2(transpose(lines)) + 100 * solve_2(lines)
end

puts "Part 1: #{groups.map {|g| value(g)}.sum}"
puts "Part 2: #{groups.map {|g| value_2(g)}.sum}"
