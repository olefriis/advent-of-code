require 'set'

groups = File.read('input').split("\n\n")

answers_per_group = groups.map do |group|
  answers = 'abcdefghijklmnopqrstuvwxyz'.chars
  group.lines {|line| answers &= line.chars}
  answers
end

number_of_answers_per_group = answers_per_group.map(&:count)
result = number_of_answers_per_group.reduce(&:+)

puts result
