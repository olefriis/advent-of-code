lines = File.readlines('03/input').map(&:strip)

part_1 = 0

lines.each do |line|
  joltages = line.chars.map(&:to_i)
  biggest_first_joltage = joltages[0..-2].max
  first_joltage_index = joltages.index(biggest_first_joltage)
  remaining_joltages = joltages[first_joltage_index + 1..-1]
  biggest_second_joltage = remaining_joltages.max
  part_1 += biggest_first_joltage * 10 + biggest_second_joltage
end

puts "Part 1: #{part_1}"
