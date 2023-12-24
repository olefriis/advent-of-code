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

points_and_directions = lines.map do |line|
  x, y, z, vx, vy, vz = line.gsub(' @ ', ', ').split(', ')
  PointAndDirection.new(x.to_f, y.to_f, z.to_f, vx.to_f, vy.to_f, vz.to_f)
end

at_least = 200000000000000
at_most = 400000000000000

result = 0
points_and_directions.each_with_index do |pad_1, i|
  (i+1).upto(lines.length - 1) do |i2|
    pad_2 = points_and_directions[i2]
    intersection, time_1, time_2 = intersection_xy(pad_1, pad_2)
    if time_1 >= 0 && time_2 >= 0 && intersection[0].between?(at_least, at_most) && intersection[1].between?(at_least, at_most)
      result += 1
    end
  end
end

puts "Part 1: #{result}"
