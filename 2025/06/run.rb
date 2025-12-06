lines = File.readlines('06/input').map(&:chomp)

def operate(numbers, operator)
  operators = {'+'=> :+, '*'=> :*}
  numbers.reduce(operators[operator] || raise("Unknown operator: #{operator}"))
end

rows = lines.map {_1.split(' ')}
operators = rows.last
regular_number_columns = rows[0..-2].map {_1.map(&:to_i)}.transpose
part_1 = regular_number_columns.zip(operators).map {operate(_1, _2)}.sum
puts "Part 1: #{part_1}"

current_numbers, part_2 = [], 0
lines.map(&:chars).transpose.reverse.reject {_1.all?(' ')}.each do |line|
  current_numbers << line[0..-2].join.to_i
  operator = line.last
  if operator != ' '
    part_2 += operate(current_numbers, operator)
    current_numbers = []
  end
end
puts "Part 2: #{part_2}"
