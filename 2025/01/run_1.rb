lines = File.readlines('01/input').map(&:strip)

dial = 50
password = 0

lines.each do |line|
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
  password += 1 if dial % 100 == 0
end

puts password
