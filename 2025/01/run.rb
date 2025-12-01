lines = File.readlines('01/input').map(&:strip)

dial, part_1, part_2 = 50, 0, 0

lines.each do |line|
  direction, amount = line[0], line[1..].to_i
  case direction
  when 'R'
    dial += amount
    part_2 += dial / 100
    dial %= 100
  when 'L'
    was_zero = dial == 0
    dial -= amount

    part_2 -= dial / 100
    dial %= 100
    part_2 -= 1 if was_zero  # Don't count previous 0 twice
    part_2 += 1 if dial == 0 # ...but count if we end up at 0
  else
    raise "Unknown direction: #{direction}"
  end

  part_1 += 1 if dial == 0
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
