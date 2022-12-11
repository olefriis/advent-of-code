instructions = File.readlines('10/input', chomp: true)

x = 1
x_values = [x]

instructions.each do |instruction|
  x_values << x
  if instruction == 'noop'
    # do nothing
  elsif instruction.start_with?('addx')
    x += instruction.split.last.to_i
    x_values << x
  end
end

signal_strength_sum = [20, 60, 100, 140, 180, 220].map { |cycle| cycle * x_values[cycle-1] }.sum
puts "Part 1: #{signal_strength_sum}"

puts "Part 2:"
x_values.each_with_index do |x, i|
  pixel = i % 40
  puts '' if pixel == 0 && i > 0
  print(if x >= pixel-1 && x < pixel + 2 ? '#' : '.')
end
