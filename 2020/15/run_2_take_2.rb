#numbers = [0,3,6]
numbers = [9,3,1,0,8,4]

last_spoken_numbers = {}
0.upto(numbers.length-2) do |n|
  last_spoken_numbers[numbers[n]] = n
end

last_number = numbers.last
# ...upto(..) is about 1 second slower than doing a while loop. But nicer I guess :-)
numbers.length.upto(30000000 - 1) do |iteration|
  last_spoken_at = last_spoken_numbers[last_number]

  new_number = last_spoken_at ? (iteration - last_spoken_at - 1) : 0

  last_spoken_numbers[last_number] = (iteration - 1)
  last_number = new_number
  iteration += 1
end

puts last_number
