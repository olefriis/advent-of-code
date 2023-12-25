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
-1000.upto(1000) do |vx|
  next unless diffs_x.all? { |velocity, diffs| diffs.all? { |diff| vx != velocity && diff % (vx - velocity) == 0 } }

  -1000.upto(1000) do |vy|
    next unless diffs_y.all? { |velocity, diffs| diffs.all? { |diff| vy != velocity && diff % (vy - velocity) == 0 } }

    -1000.upto(1000) do |vz|
      next unless diffs_z.all? { |velocity, diffs| diffs.all? { |diff| vz != velocity && diff % (vz - velocity) == 0 } }

      potential_velocities << [vx, vy, vz]
    end
  end
end

# Part 2 solution HEAVILY inspired by https://www.reddit.com/r/adventofcode/comments/18pnycy/comment/keqf8uq/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
raise "Unexpected number of velocities: #{potential_velocities}" if potential_velocities.length != 1
rock_vx, rock_vy, rock_vz = potential_velocities.first
pad_1, pad_2 = $points_and_directions[0..1] # Pick the first two hailstones. Hopefully these are not parallel...
ma = (pad_1.vy - rock_vy) / (pad_1.vx.to_f - rock_vx)
mb = (pad_2.vy - rock_vy) / (pad_2.vx.to_f - rock_vx)
ca = pad_1.y - ma * pad_1.x
cb = pad_2.y - mb * pad_2.x
pos_x = ((cb - ca) / (ma - mb)).round
pos_y = (ma * pos_x + ca).round
time = (pos_x - pad_1.x) / (pad_1.vx - rock_vx)
pos_z = (pad_1.z + (pad_1.vz - rock_vz) * time).round

puts "Part 2: #{pos_x + pos_y + pos_z}"
