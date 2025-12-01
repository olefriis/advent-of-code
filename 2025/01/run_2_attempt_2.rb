lines = File.readlines('01/input').map(&:strip)

dial = 50
password = 0

lines.each do |line|
  old_dial = dial
  direction = line[0]
  amount = line[1..].to_i
  case direction
  when 'R'
    amount.times do
      dial = (dial + 1) % 100
      password += 1 if dial == 0
    end
    puts "Going right #{amount}, dial is now #{dial}"
  when 'L'
    amount.times do
      dial = (dial - 1) % 100
      password += 1 if dial == 0
    end
    puts "Going left #{amount}, dial is now #{dial}"
  else
    raise "Unknown direction: #{direction}"
  end
end

puts password
