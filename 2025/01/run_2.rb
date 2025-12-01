lines = File.readlines('01/input').map(&:strip)

dial = 50
password = 0

lines.each do |line|
  old_dial = dial
  direction = line[0]
  amount = line[1..].to_i
  case direction
  when 'R'
    dial += amount
    puts "Going right #{amount}, dial is now #{dial}"
  when 'L'
    dial -= amount
    puts "Going left #{amount}, dial is now #{dial}"
  else
    raise "Unknown direction: #{direction}"
  end
  if dial == 0
    password += 1
  elsif dial < 0
    if old_dial == 0
      # Don't count twice
      dial += 100
    end
    while dial < 0
      dial += 100
      password += 1
    end
  elsif dial >= 100
    while dial >= 100
      dial -= 100
      password += 1
    end
  end
  puts " Dial is #{dial}. Password is now #{password}"
end

puts password
