require 'set'
lines = File.readlines('input').map(&:strip)

Point = Struct.new(:x, :y, :z, :w) do
  def plus(p)
    Point.new(x + p.x, y + p.y, z + p.z, w + p.w)
  end
end

def neighbouring_points_to(p)
  result = []
  -1.upto(1) do |x|
    -1.upto(1) do |y|
      -1.upto(1) do |z|
        -1.upto(1) do |w|
          result << Point.new(p.x + x, p.y + y, p.z + z, p.w + w) unless x == 0 && y == 0 && z == 0 && w == 0
        end
      end
    end
  end
  result
end

active_points = Set.new()
lines.each_with_index do |line, y|
  line.split('').each_with_index do |char, x|
    active_points << Point.new(x, y, 0, 0) if char == '#'
  end
end

puts "Starting with #{active_points.count} active points"

6.times do |iteration|
  all_neighbouring_points = active_points.flat_map {|p| neighbouring_points_to(p)}
  points_to_consider = active_points + all_neighbouring_points

  puts "#{points_to_consider.count} points to consider"

  active_points = Set.new(points_to_consider.select do |point|
    active_neighbours = neighbouring_points_to(point).count {|p| active_points.include?(p)}
    is_active = active_points.include?(point)

    if is_active
      [2, 3].include?(active_neighbours)
    else
      active_neighbours == 3
    end
  end)

  puts "#{iteration}: #{active_points.count} active points"
end
