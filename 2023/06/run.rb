lines = File.readlines('06/input').map(&:strip)

def solve(times_and_distances)
  times_and_distances.map do |time, distance|
    time.times.count { |i| (time - i) * i > distance }
  end.inject(&:*)
end

times = lines.first.scan(/\d+/).map(&:to_i)
distances = lines.last.scan(/\d+/).map(&:to_i)
times_and_distances = times.zip(distances)
puts "Part 1: #{solve(times_and_distances)}"

time = lines.first.scan(/\d+/).join.to_i
distance = lines.last.scan(/\d+/).join.to_i
puts "Part 2: #{solve([[time, distance]])}"
