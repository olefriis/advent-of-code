lines = File.readlines('09/input').map(&:strip)

def complete_forwards(numbers)
  next_line = numbers.each_cons(2).map {|a, b| b - a}
  if next_line.all?(0)
    numbers + [numbers.last]
  else
    completed_next_line = complete_forwards(next_line)
    numbers + [numbers.last + completed_next_line.last]
  end
end

def complete_backwards(numbers)
  next_line = numbers.each_cons(2).map {|a, b| b - a}
  if next_line.all?(0)
    [numbers.first] + numbers
  else
    completed_next_line = complete_backwards(next_line)
    [numbers.first - completed_next_line.first] + numbers
  end
end

number_lines = lines.map {|line| line.split(' ').map(&:to_i)}

part1 = number_lines.map {|numbers| complete_forwards(numbers).last}.sum
puts "Part 1: #{part1}"

part2 = number_lines.map {|numbers| complete_backwards(numbers).first}.sum
puts "Part 2: #{part2}"
