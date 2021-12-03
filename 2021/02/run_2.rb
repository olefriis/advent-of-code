lines = File.readlines('input')
aim = 0
depth = 0
hpos = 0

lines.each do |line|
  command, value = line.split(' ')
  case command
  when 'forward' then
    hpos += value.to_i
    depth += aim * value.to_i
  when 'up' then aim -= value.to_i
  when 'down' then aim += value.to_i
  end
end

puts "Final position: #{hpos}"
puts "Final depth: #{depth}"
puts "Result: #{hpos * depth}"
