#lines = File.readlines('input').map(&:strip)

#card_public_key = 5764801
#door_public_key = 17807724
card_public_key = 14205034
door_public_key = 18047856

def loop_value_for(public_key)
  value = 1
  subject_number = 7
  loop_number = 1
  loop do
    value = (value * subject_number) % 20201227
    return loop_number if value == public_key
    loop_number += 1
  end
end

loop_value_for_card = loop_value_for(card_public_key)
loop_value_for_door = loop_value_for(door_public_key)
puts loop_value_for_card
puts loop_value_for_door

value = card_public_key
(loop_value_for_door-1).times do
  value = (value * card_public_key) % 20201227
end

puts value
