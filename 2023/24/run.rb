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

at_least = 200000000000000
at_most = 400000000000000

result = 0
$points_and_directions.each_with_index do |pad_1, i|
  (i+1).upto(lines.length - 1) do |i2|
    pad_2 = $points_and_directions[i2]
    intersection, time_1, time_2 = intersection_xy(pad_1, pad_2)
    if time_1 >= 0 && time_2 >= 0 && intersection[0].between?(at_least, at_most) && intersection[1].between?(at_least, at_most)
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

velocities_x = {}
velocities_y = {}
velocities_z = {}
$points_and_directions.each do |pad|
  velocities_x[pad.vx] ||= []
  velocities_x[pad.vx] << pad.x

  velocities_y[pad.vy] ||= []
  velocities_y[pad.vy] << pad.y

  velocities_z[pad.vz] ||= []
  velocities_z[pad.vz] << pad.z
end

def diffs(velocities)
  velocities.
    select { |diff, pads| pads.length > 1 }.
    map { |diff, velocities| [diff, velocities.sort.each_cons(2).map { |a, b| b - a }] }
end

diffs_x = diffs(velocities_x)
diffs_y = diffs(velocities_y)
diffs_z = diffs(velocities_z)
potential_velocities = []
rock_vx = nil
-1000.upto(1000) do |potential_vx|
  if diffs_x.all? { |velocity, diffs| diffs.all? { |diff| potential_vx != velocity && diff % (potential_vx - velocity) == 0 } }
    rock_vx = potential_vx
    break
  end
end
raise "No potential rock velocity for x coordinate" unless rock_vx

rock_vy = nil
-1000.upto(1000) do |potential_vy|
  if diffs_y.all? { |velocity, diffs| diffs.all? { |diff| potential_vy != velocity && diff % (potential_vy - velocity) == 0 } }
    rock_vy = potential_vy
    break
  end
end
raise "No potential rock velocity for y coordinate" unless rock_vy

rock_vz = nil
-1000.upto(1000) do |potential_vz|
  if diffs_z.all? { |velocity, diffs| diffs.all? { |diff| potential_vz != velocity && diff % (potential_vz - velocity) == 0 } }
    rock_vz = potential_vz
    break
  end
end
raise "No potential rock velocity for z coordinate" unless rock_vz

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
puts "Part 2: #{(rock_origin[0] + rock_origin[1] + rock_origin[2]).round}"
