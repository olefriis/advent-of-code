input = File.readlines('20/input', chomp: true).map(&:to_i)

Num = Struct.new(:value, :original_pos)

def solve(input, times)
  original_numbers = input.each_with_index.map {|n, i| Num.new(n, i)}
  numbers = original_numbers.dup

  times.times do |i|
    puts "Iteration #{i}"
    original_numbers.each do |num|
      current_index = numbers.index(num)
      numbers.delete_at(current_index)

      new_index = (current_index + num.value) % numbers.length
      numbers.insert(new_index, num)
    end
  end

  index_of_0 = numbers.index {|number| number.value == 0}
  number1 = numbers[(index_of_0 + 1000) % numbers.length].value
  number2 = numbers[(index_of_0 + 2000) % numbers.length].value
  number3 = numbers[(index_of_0 + 3000) % numbers.length].value
  number1 + number2 + number3
end

puts "Part 1: #{solve(input, 1)}"

part2_input = input.map {|n| n * 811589153}
puts "Part 2: #{solve(part2_input, 10)}"
