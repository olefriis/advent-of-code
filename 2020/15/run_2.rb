require 'pry'
#numbers = [0,3,6]
numbers = [9,3,1,0,8,4]

last_spoken_numbers = {}
0.upto(numbers.length-2) do |n|
  last_spoken_numbers[numbers[n]] = n
end

while numbers.length < 30000000
  last_number = numbers.last
  last_spoken_at = last_spoken_numbers[last_number]

  new_number = last_spoken_at ? (numbers.length - last_spoken_at - 1) : 0
  binding.pry

  last_spoken_numbers[last_number] = (numbers.length - 1)
  numbers << new_number
end

puts numbers.last
