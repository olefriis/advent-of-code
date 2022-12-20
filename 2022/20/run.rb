require 'pry'
numbers = File.readlines('20/input', chomp: true).map(&:to_i)
original_numbers = numbers.dup

#puts 'Initial arrangement:'
#puts "#{numbers}\n\n"

original_numbers.each do |number|
  next if number == 0
  current_index = numbers.index(number)
  numbers.delete_at(current_index)

  new_index = current_index + number
  #new_index -= 1 if number < 0 && new_index < 0
  new_index = (new_index + 1000*numbers.length) % numbers.length
  #puts "New index: #{new_index}"

  to_insert_after = numbers[new_index]
  to_insert_before = numbers[(new_index+1) % numbers.length]
  #puts "#{number} moves between #{to_insert_after} and #{to_insert_before}:"
  numbers.insert(new_index, number)
  #puts "#{numbers.inspect}\n\n"
end

index_of_0 = numbers.index(0)
number1 = numbers[(index_of_0 + 1000) % numbers.length]
number2 = numbers[(index_of_0 + 2000) % numbers.length]
number3 = numbers[(index_of_0 + 3000) % numbers.length]
puts "Number 1: #{number1}"
puts "Number 2: #{number2}"
puts "Number 3: #{number3}"
coordinates = number1 + number2 + number3
puts "Part 1: #{coordinates}"

# -3793: Wrong
# 17994: Too high
# -4915: Wrong