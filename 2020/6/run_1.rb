require 'set'

groups = File.read('input').split("\n\n")

answers_per_group = groups.map do |group|
  answers = Set.new
  group.gsub(/[a-z]/) {|c| answers << c}
  answers
end

number_of_answers_per_group = answers_per_group.map(&:count)
result = number_of_answers_per_group.reduce(&:+)

puts result
