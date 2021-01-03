MAGIC_NUMBER=776203571
#MAGIC_NUMBER=127

numbers = File.readlines('input').map(&:to_i)

1.upto(numbers.count) do |i|
  sum = 0
  numbers_to_sum = []
  (i-1).downto(0) do |i2|
    sum += numbers[i2]
    numbers_to_sum << numbers[i2]
    if sum == MAGIC_NUMBER
      puts "Lines #{i2+1}..#{i} sum to #{MAGIC_NUMBER}: #{numbers_to_sum}"
      max, min = numbers_to_sum.max, numbers_to_sum.min
      puts "Max: #{max}. Min: #{min}. Sum: #{max+min}."
      exit
    end
  end
end
