# This is the elegant-but-broken solution to part 2.

require 'pry'
lines = File.readlines("18/input").map(&:strip)

grid = Set.new

DIRECTIONS = {
  'U' => [0, -1],
  'D' => [0, 1],
  'L' => [-1, 0],
  'R' => [1, 0]
}

Segment = Struct.new(:x1, :y1, :x2, :y2) do
  def direction
    x1 == x2 ? :vertical : :horizontal
  end

  def vertical?
    direction == :vertical
  end

  def contains_y(y)
    miny, maxy = [y1, y2].sort
    miny <= y && maxy >= y
  end

  def contains_x(x)
    minx, maxx = [x1, x2].sort
    minx <= x && maxx >= x
  end

  def vertical_direction
    raise "Not a vertical line" if x1 != x2
    if y1 < y2
      :down
    else
      :up
    end
  end
end

segments = []

px = py = 0
grid << [px, py]
lines.each do |line|
  line =~ /\(\#([0-9a-f]{5})([0-3])\)/ or raise "Bad hex: #{hex}"
  amount, direction = $1, $2
  direction = {
    '0' => 'R',
    '1' => 'D',
    '2' => 'L',
    '3' => 'U'
  }[direction]
  amount = amount.to_i(16)

  newx = px
  newy = py
  case direction
  when 'U'
    newy = py - amount
  when 'D'
    newy = py + amount
  when 'L'
    newx = px - amount
  when 'R'
    newx = px + amount
  end
  puts "#{direction} #{amount}"
  segments << Segment.new(px, py, newx, newy)
  px = newx
  py = newy
end

# Reverse the direction of all vertical lines so it fits our algorithm below
segments = segments.map { |s| s.direction == :vertical ? Segment.new(s.x2, s.y2, s.x1, s.y1) : s }

segments.select(&:vertical?).sort_by {|s| [s.y1, s.y2].min }.each do |s|
  puts "(#{s.x1},#{s.y1}) -> (#{s.x2},#{s.y2})"
end

puts "Segments: #{segments}"

segments.select { |s| s.direction == :horizontal }.each do |horizontal|
  intersecting = segments.select { |s2| s2.direction == :vertical && s2.contains_y(horizontal.y1) && horizontal.contains_x(s2.x1) }.each do |vertical|
    min_y, max_y = [vertical.y1, vertical.y2].sort
    if min_y < horizontal.y1 && max_y > horizontal.y1
      raise "Intersection! #{horizontal}, #{vertical})"
    end
  end
end


part2 = 0
relevant_ys = segments.flat_map { |s| [s.y1, s.y2] }.uniq.sort
min_y = segments.flat_map {|s| [s.y1, s.y2] }.min
puts "Min y: #{min_y}"
y = relevant_ys.first
relevant_ys.each_with_index do |y, i|
  puts "**** y: #{y}"
  vertical_lines = segments.select { |s| s.direction == :vertical && s.contains_y(y) }.sort_by(&:x1)

  horizontal_area_only_for_this_line = 0
  area_relevant_for_next_many_lines = 0

  raise "Excpected vertical lines!" if vertical_lines.empty?
  vertical_lines.each do |line|
    puts "#{line.vertical_direction} (#{line.x1},#{line.y1}) -> (#{line.x2} #{line.y2})"
  end

  while !vertical_lines.empty?
    # Consume the upcoming downwards lines
    downwards_lines = []
    while vertical_lines.first.vertical_direction == :down
      downwards_lines << vertical_lines.shift
    end
    raise "Expecting one or two downwards lines! #{downwards_lines}" if downwards_lines.empty? || downwards_lines.size > 2

    # Consume the upcoming upwards lines
    upwards_lines = []
    while vertical_lines.first&.vertical_direction == :up
      upwards_lines << vertical_lines.shift
    end
    raise "Expecting one or two upwards lines! #{upwards_lines}" if upwards_lines.empty? || upwards_lines.size > 2

    downwards_lines_for_future = downwards_lines.select { |s| s.y2 > y }
    raise "More than one downwards line for future!" if downwards_lines_for_future.size > 1
    upwards_lines_for_future = upwards_lines.select { |s| s.y1 > y }
    raise "More than one upwards line for future!" if upwards_lines_for_future.size > 1
    raise "Different number of lines for future!" if downwards_lines_for_future.size != upwards_lines_for_future.size

    downwards_lines_now_irrelevant = downwards_lines - downwards_lines_for_future
    upwards_lines_now_irrelevant = upwards_lines - upwards_lines_for_future
    downwards_lines_now_irrelevant.each { |line| raise "Not irrelevant #{line}" if line.y2 != y }
    upwards_lines_now_irrelevant.each { |line| raise "Not irrelevant #{line}" if line.y1 != y }

    if downwards_lines_for_future.length == 1
      min_x, max_x = (downwards_lines_for_future + upwards_lines_for_future).map(&:x1).minmax
      area_relevant_for_next_many_lines += (max_x - min_x + 1)
    end

    min_x, max_x = (upwards_lines + downwards_lines).map(&:x1).minmax
    horizontal_area_covered = max_x - min_x + 1
    puts "Horizontal area covered: #{horizontal_area_covered}"
    horizontal_area_only_for_this_line += horizontal_area_covered
  end

  puts ""
  puts "Horizontal area only for this line: #{horizontal_area_only_for_this_line}"
  puts "Area relevant for next many lines: #{area_relevant_for_next_many_lines}"
  part2 += horizontal_area_only_for_this_line

  next_relevant_y = relevant_ys[i+1]

  if next_relevant_y
    part2 += area_relevant_for_next_many_lines * (next_relevant_y - y - 1)
  else
    raise "Expected no more relevant lines" if !downwards_lines_for_future.empty? || !upwards_lines_for_future.empty?
    puts "Done"
  end

  y = next_relevant_y
end

puts "This is not part 2: #{part2}"
