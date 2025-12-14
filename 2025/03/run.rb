lines = File.readlines('03/input').map(&:strip)

def biggest_joltage(joltages, number_of_batteries)
  return 0 if number_of_batteries == 0

  biggest_valid_joltage = joltages[0..-number_of_batteries].max
  biggest_joltage_index = joltages.index(biggest_valid_joltage)
  10**(number_of_batteries - 1) * biggest_valid_joltage +
    biggest_joltage(joltages[biggest_joltage_index + 1..], number_of_batteries - 1)
end

part_1, part_2 = 0, 0
lines.each do |line|
  joltages = line.chars.map(&:to_i)
  part_1 += biggest_joltage(joltages, 2)
  part_2 += biggest_joltage(joltages, 12)
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
