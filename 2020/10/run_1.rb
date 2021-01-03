numbers = [0, *File.readlines('input').map(&:to_i).sort]
p numbers
numbers << numbers.last + 3

one_jolts, three_jolts = 0, 0
0.upto(numbers.count-2) do |i|
  diff = numbers[i+1] - numbers[i]
  one_jolts += 1 if diff == 1
  three_jolts += 1 if diff == 3
end

puts "1 jolt jumps: #{one_jolts} 3 jolt jumps: #{three_jolts}. Multiplied: #{one_jolts * three_jolts}"
