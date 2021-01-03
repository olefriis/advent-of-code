require 'set'
PREAMBLE=25

numbers = File.readlines('input').map(&:to_i)
sums = []

numbers.each_with_index do |number, i|
  if i > PREAMBLE
    check_from = i - PREAMBLE
    check_to = i - 1
    unless sums[check_from..check_to].any? { |sum| sum.include? number }
      raise "Number on line #{i+1}, which is #{number} is invalid" 
    end
  end

  create_sums_from = [0,i-PREAMBLE].max
  create_sums_to = i
  sums[create_sums_from..create_sums_to].each_with_index { |sum, sum_i| sum << numbers[sum_i + create_sums_from] + number }

  sums[i] = Set.new
end

puts 'All numbers match?'