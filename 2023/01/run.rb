lines = File.readlines('01/input').map(&:strip)

DIGITS = { '0' => 0, '1' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9 }
DIGITS_AND_WORDS = DIGITS.merge('one' => 1, 'two' => 2, 'three' => 3, 'four' => 4, 'five' => 5, 'six' => 6, 'seven' => 7, 'eight' => 8, 'nine' => 9)

def first_number(s, vocabulary)
  loop do
    vocabulary.keys.each { |key| return vocabulary[key] if s.start_with?(key) }
    s = s[1..-1]
  end
end

def last_number(s, vocabulary)
  loop do
    vocabulary.keys.each { |key| return vocabulary[key] if s.end_with?(key) }
    s = s[0..-2]
  end
end

part_1 = lines.map { |line| first_number(line, DIGITS) * 10 + last_number(line, DIGITS) }.sum
part_2 = lines.map { |line| first_number(line, DIGITS_AND_WORDS) * 10 + last_number(line, DIGITS_AND_WORDS) }.sum

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"