lines = File.readlines('input').map(&:chomp)

def count_leading(lines)
  result = [0, 0]
  lines.each do |line|
    result[0] += 1 if line[0] == '0'
    result[1] += 1 if line[0] == '1'
  end
  result
end

o2_digits = ''
lines_for_o2 = lines.clone
while lines_for_o2.count > 1
  counts = count_leading(lines_for_o2)
  winning_cipher = counts[1] >= counts[0] ? '1' : '0'
  o2_digits += winning_cipher
  lines_for_o2 = lines_for_o2
    .select { |line| line[0] == winning_cipher }
    .map { |line| line[1..-1] }
end
o2_number = o2_digits + lines_for_o2.first
puts "oxygen number: #{o2_number}"


scrubber_digits = ''
lines_for_scrubber = lines.clone
while lines_for_scrubber.count > 1
  counts = count_leading(lines_for_scrubber)
  winning_cipher = counts[1] < counts[0] ? '1' : '0'
  scrubber_digits += winning_cipher
  lines_for_scrubber = lines_for_scrubber
    .select { |line| line[0] == winning_cipher }
    .map { |line| line[1..-1] }
end
scrubber_number = scrubber_digits + lines_for_scrubber.first
puts "scrubber number: #{scrubber_number}"

puts "Result: #{scrubber_number.to_i(2) * o2_number.to_i(2)}"
