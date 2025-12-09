lines = File.readlines('09/input').map(&:strip)
positions = lines.map { |line| line.split(',').map(&:to_i) }

part_1 = 0
positions.combination(2).map do |(x1, y1), (x2, y2)|
  width = (x2 - x1).abs + 1
  height = (y2 - y1).abs + 1
  area = width * height
  puts "(#{x1}, #{y1}) to (#{x2}, #{y2}): area #{area}"
  part_1 = [part_1, area].max
end

puts "Part 1: #{part_1}"