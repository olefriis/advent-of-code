lines = File.readlines('03/input').map(&:strip)

def biggest_joltage(joltages, number_of_batteries)
  result = 0
  number_of_batteries.downto(1) do |i|
    biggest_valid_joltage = joltages[0..-i].max
    biggest_joltage_index = joltages.index(biggest_valid_joltage)
    result = result * 10 + biggest_valid_joltage
    joltages = joltages[biggest_joltage_index + 1..-1]
  end
  result
end

part_1, part_2 = 0, 0
lines.each do |line|
  joltages = line.chars.map(&:to_i)
  part_1 += biggest_joltage(joltages, 2)
  part_2 += biggest_joltage(joltages, 12)
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
