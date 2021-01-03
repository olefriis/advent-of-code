numbers = [0,3,6]
#numbers = [9,3,1,0,8,4]

while numbers.length < 2020
  last_number = numbers[numbers.length-1]

  last_spoken_at = (numbers.length-2).downto(0).find {|i| numbers[i] == last_number}
  #puts "Last number #{last_number} was last spoken at #{last_spoken_at}, which is #{numbers.length - (last_spoken_at || 0) - 1} times ago"
  if last_spoken_at
    numbers << numbers.length - last_spoken_at - 1
  else
    numbers << 0
  end
end

puts numbers.last
