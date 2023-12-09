def extrapolate_forwards(numbers)
  next_line = numbers.each_cons(2).map {|a, b| b - a}
  if next_line.all?(0)
    numbers.last
  else
    numbers.last + extrapolate_forwards(next_line)
  end
end

def extrapolate_backwards(numbers)
  next_line = numbers.each_cons(2).map {|a, b| b - a}
  if next_line.all?(0)
    numbers.first
  else
    numbers.first - extrapolate_backwards(next_line)
  end
end

lines = File.readlines('09/input').map(&:strip).map {|line| line.split(' ').map(&:to_i)}

part1 = lines.map {|line| extrapolate_forwards(line)}.sum
puts "Part 1: #{part1}"

part2 = lines.map {|line| extrapolate_backwards(line)}.sum
puts "Part 2: #{part2}"
