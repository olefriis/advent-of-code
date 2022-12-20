require 'pry'
input = File.readlines('20/input', chomp: true).map(&:to_i)

Num = Struct.new(:value, :original_pos)

original_numbers = input.each_with_index.map {|n, i| Num.new(n, i)}
numbers = original_numbers.dup

original_numbers.each do |num|
  next if num.value == 0
  current_index = numbers.index(num)
  numbers.delete_at(current_index)

  new_index = current_index + num.value
  new_index = (new_index + 1000*numbers.length) % numbers.length

  if new_index == 0
    numbers << num # ...because the example does this!
  else
    numbers.insert(new_index, num)
  end
end

zero = original_numbers.find {|n| n.value == 0}
index_of_0 = numbers.index(zero)
number1 = numbers[(index_of_0 + 1000) % numbers.length].value
number2 = numbers[(index_of_0 + 2000) % numbers.length].value
number3 = numbers[(index_of_0 + 3000) % numbers.length].value
coordinates = number1 + number2 + number3
puts "Part 1: #{coordinates}"
