lines = File.readlines('01/input').map(&:strip)

DIGITS = { '0' => 0, '1' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9 }
DIGITS_AND_WORDS = DIGITS.merge('one' => 1, 'two' => 2, 'three' => 3, 'four' => 4, 'five' => 5, 'six' => 6, 'seven' => 7, 'eight' => 8, 'nine' => 9)

def to_numbers(s, vocabulary)
  0.upto(s.size - 1).map do |i|
    matching_word = vocabulary.keys.find { |key| s[i..-1].start_with?(key) }
    matching_word ? vocabulary[matching_word] : nil
  end.compact
end

part_1 = lines.map { |line| numbers = to_numbers(line, DIGITS); numbers.first * 10 + numbers.last }.sum
part_2 = lines.map { |line| numbers = to_numbers(line, DIGITS_AND_WORDS); numbers.first * 10 + numbers.last }.sum

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"