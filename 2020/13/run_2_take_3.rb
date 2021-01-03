lines = File.readlines('input').map(&:strip)
buses = lines[1].split(',').each_with_index.reject {|b, _| b == 'x'}.map {|b, i| [b.to_i, i]}

start_time = 0
while (matches = buses.reject {|bus, offset| (start_time + offset) % bus != 0 }) != buses
  start_time += matches.map(&:first).reduce(&:*)
end

puts start_time
