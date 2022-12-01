lines = File.readlines('01/input').map(&:strip)
elves = []
current_elf = 0

lines.each do |line|
  if line.empty?
    elves << current_elf
    current_elf = 0
  else
    current_elf += line.to_i
  end
end
elves << current_elf

puts "Part 1: #{elves.max}"
puts "Part 2: #{elves.sort.reverse[0..2].sum}"
