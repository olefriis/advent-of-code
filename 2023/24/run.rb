lines = File.readlines("24/input").map(&:strip)

PointAndDirection = Struct.new(:x, :y, :z, :vx, :vy, :vz) do
  def at(time)
    [x + vx * time, y + vy * time, z + vz * time]
  end
end

def intersection_xy(pad_1, pad_2)
  t = (-pad_1.y + pad_2.y - pad_1.vy * pad_2.x / pad_1.vx + pad_1.vy * pad_1.x / pad_1.vx) / (pad_1.vy * pad_2.vx / pad_1.vx - pad_2.vy)
  s = (-pad_1.y + pad_2.y + pad_1.x * pad_2.vy / pad_2.vx - pad_2.x * pad_2.vy / pad_2.vx) / (pad_1.vy - pad_1.vx * pad_2.vy / pad_2.vx)

  [pad_1.at(s), s, t]
end

$points_and_directions = lines.map do |line|
  x, y, z, vx, vy, vz = line.gsub(' @ ', ', ').split(', ')
  PointAndDirection.new(x.to_f, y.to_f, z.to_f, vx.to_f, vy.to_f, vz.to_f)
end

min_area = 200000000000000
max_area = 400000000000000

result = 0
$points_and_directions.each_with_index do |pad_1, i|
  (i+1).upto(lines.length - 1) do |i2|
    pad_2 = $points_and_directions[i2]
    intersection, time_1, time_2 = intersection_xy(pad_1, pad_2)
    if time_1 >= 0 && time_2 >= 0 && intersection[0].between?(min_area, max_area) && intersection[1].between?(min_area, max_area)
      result += 1
    end
  end
end

puts "Part 1: #{result}"

# For part 2, our strategy is to first find the velocity of the rock, and then find the starting position/origin of the rock.

# For the velocity of the rock, we find the velocities for X, Y, and Z independently. For each coordinate, what we know is that
# when we have a pair of hailstones with the same veolocity (for X, Y, or Z, resp.), the corresponding rock coordinate must
# fulfill "diff % (rock_velocity - hailstone_velocity) == 0", where diff is the difference between the two hailstones' coordinates,
# rock_velocity is the velocity of the rock for the given coordinate, and hailstone_velocity is the common velocity for the two
# hailstones.

def diffs_for_coordinate(position_attribute, velocity_attribute)
  relevant_velocities = $points_and_directions.map(&velocity_attribute).uniq
  relevant_velocities.map do |velocity|
    pads = $points_and_directions.select { |pad| pad.send(velocity_attribute) == velocity }
    [velocity, pads.each_cons(2).map { |a, b| b.send(position_attribute) - a.send(position_attribute) }]
  end
end

diffs_x = diffs_for_coordinate(:x, :vx)
diffs_y = diffs_for_coordinate(:y, :vy)
diffs_z = diffs_for_coordinate(:z, :vz)

def is_suiting_velocity?(v, diffs_for_coordinate)
  diffs_for_coordinate.all? { |velocity, diffs| diffs.all? { |diff| v != velocity && diff % (v - velocity) == 0 } }  
end

rock_vx = (-1000..1000).find { |potential_vx| is_suiting_velocity?(potential_vx, diffs_x) } or raise "No potential rock velocity for x coordinate"
rock_vy = (-1000..1000).find { |potential_vy| is_suiting_velocity?(potential_vy, diffs_y) } or raise "No potential rock velocity for y coordinate"
rock_vz = (-1000..1000).find { |potential_vz| is_suiting_velocity?(potential_vz, diffs_z) } or raise "No potential rock velocity for z coordinate"

# Now for the origin of the rock. We know that at some time t, the rock will be at the same position as the first hailstone. In
# other words:
# origin_rock + t * velocity_rock = origin_hailstone_1 + t * velocity_hailstone_1
# ...which is the same as
# origin_rock = origin_hailstone_1 + t * (velocity_hailstone_1 - velocity_rock)
#
# In the same way, we also get that
# origin_rock = origin_hailstone_2 + t * (velocity_hailstone_2 - velocity_rock)
#
# This means we can consider both possible origins for the rock as lines, and we can model those as hailstone paths (we have
# a starting position and a velocity). And we just find the intersection of the two, reusing our intersection_xy method from
# part 1.

pad_1, pad_2 = $points_and_directions[0..1] # Pick the first two hailstones. Hopefully these are not parallel...
pad_1_for_rock_origin = PointAndDirection.new(pad_1.x, pad_1.y, pad_1.z, pad_1.vx - rock_vx, pad_1.vy - rock_vy, pad_1.vz - rock_vz)
pad_2_for_rock_origin = PointAndDirection.new(pad_2.x, pad_2.y, pad_2.z, pad_2.vx - rock_vx, pad_2.vy - rock_vy, pad_2.vz - rock_vz)
crossing_potential_rock_origins = intersection_xy(pad_1_for_rock_origin, pad_2_for_rock_origin)
rock_origin = pad_1_for_rock_origin.at(crossing_potential_rock_origins[1])

puts "Part 2: #{rock_origin.sum.round}"
