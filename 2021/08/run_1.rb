lines = File.readlines('input').map(&:strip)

digit_lines = lines.map { |line| line.split(' | ')[1] }
easy_digits = digit_lines.map { |line| line.split(' ').count { |digit| [2, 3, 4, 7].include?(digit.length) } }

puts "#{easy_digits}"
puts easy_digits.sum
