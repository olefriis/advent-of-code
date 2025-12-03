lines = File.readlines('03/input').map(&:strip)

part_2 = 0

def largest_joltage_and_remaining(joltages, leave_out)
  biggest_valid_joltage = joltages[0..-(1 + leave_out)].max
  biggest_joltage_index = joltages.index(biggest_valid_joltage)
  [biggest_valid_joltage, joltages[biggest_joltage_index + 1..-1]]
end

lines.each do |line|
  joltages = line.chars.map(&:to_i)
  joltage = 0
  12.downto(1) do |i|
    biggest_joltage, joltages = largest_joltage_and_remaining(joltages, i-1)
    joltage = joltage * 10 + biggest_joltage
  end
  puts "Joltage: #{joltage}"
  part_2 += joltage
end

puts "Part 2: #{part_2}"
