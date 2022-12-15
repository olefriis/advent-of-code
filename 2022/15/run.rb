lines = File.readlines('15/input', chomp: true)

Sensor = Struct.new(:x, :y, :beacon_x, :beacon_y)
sensors = lines.map do |line|
  line =~ /Sensor at x=(.+), y=(.+): closest beacon is at x=(.+), y=(.+)/
  Sensor.new($1.to_i, $2.to_i, $3.to_i, $4.to_i)
end

def overlaps?(interval1, interval2)
  interval1[0] <= interval2[1] && interval2[0] <= interval1[1]
end

def combined(interval1, interval2)
  [[interval1[0], interval2[0]].min, [interval1[1], interval2[1]].max]
end

def reduce_intervals(intervals, interval)
  result = []
  intervals.each do |existing_interval|
    if overlaps?(existing_interval, interval)
      interval = combined(existing_interval, interval)
    else
      result << existing_interval
    end
  end
  result << interval
end

def beacon_free_fields_at(y, sensors)
  intervals = []
  sensors.each do |sensor|
    manhattan_distance = (sensor.x - sensor.beacon_x).abs + (sensor.y - sensor.beacon_y).abs
    next if y < sensor.y - manhattan_distance || y > sensor.y + manhattan_distance

    # Calculate the Manhattan distance to (sensor.x, y)
    z = (sensor.y - y).abs
    remaining_manhattan_distance = manhattan_distance - z
    interval = [sensor.x - remaining_manhattan_distance, sensor.x + remaining_manhattan_distance]
    intervals = reduce_intervals(intervals, interval)
  end
  intervals
end

y = 2000000
intervals = beacon_free_fields_at(y, sensors)
covered = intervals
  .map { |interval| interval[1] - interval[0] + 1 }
  .sum
beacons_at_y = sensors
  .filter { |sensor| sensor.beacon_y == y }
  .map { |sensor| [sensor.beacon_x, sensor.beacon_y] }
  .uniq
  .count

puts "Part 1: #{covered - beacons_at_y}"

# Part 2: Basically find the one point in [(0..4000000)..(0..4000000)] where the
# manhattan distance to all sensors is bigger than the manhattan distance to its
# detected beacon.
# I'll do brute-force! Fortunately this finishes in not-too-bad time.
# I'm sure you can make a "sweeping algorithm" where you sort the sensors by their
# coverage by Y, and then keep track of "upper Manhattan spikes" and "lower
# Manhattan spikes" and make it finish in milliseconds. I'm not up for that now.

def find_relevant_interval(sensors)
  0.upto(4000000) do |y|
    puts "y: #{y}" if y % 1000 == 0

    intervals = beacon_free_fields_at(y, sensors)
    intervals.each do |interval|
      if interval[0] > 0 || interval[1] < 4000000
        return [y, intervals]
      end
    end
  end
end

y, relevant_interval = find_relevant_interval(sensors)
puts "Hey, at y=#{y} we have these intervals: #{relevant_interval.inspect}"
puts "Sorry, you'll have to yourself find the x value that's not covered, and"
puts "calculate x*4000000 + #{y}."
