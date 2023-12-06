lines = File.readlines('06/input').map(&:strip)

times = lines.first.scan(/\d+/).map(&:to_i)
distances = lines.last.scan(/\d+/).map(&:to_i)

times_and_distances = times.zip(distances)
p times_and_distances

p = []
times_and_distances.each do |time, distance|
  possibilities = 0
  time.times do |i|
    remaining_time = time - i
    distance_traveled = remaining_time * i
    possibilities += 1 if distance_traveled > distance
  end
  p << possibilities
end
puts "Part 1: #{p.inject(&:*)}"

time = lines.first.scan(/\d+/).join.to_i
distance = lines.last.scan(/\d+/).join.to_i

puts "Total time: #{time}"
puts "Total distance: #{distance}"
possibilities = 0
time.times do |i|
  remaining_time = time - i
  distance_traveled = remaining_time * i
  possibilities += 1 if distance_traveled > distance
end
puts "Part 2: #{possibilities}"
