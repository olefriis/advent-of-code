lines = File.readlines("18/input").map(&:strip)

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

def solve(commands)
  px = py = 0
  segments = []
  commands.each do |direction, amount|
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
    segments << Segment.new(px, py, newx, newy)
    px = newx
    py = newy
  end

  # Ensure that the leftmost vertical line is going down
  leftmost_vertical_line = segments.select(&:vertical?).sort_by(&:x1).first
  if leftmost_vertical_line.vertical_direction == :up
    # Reverse the direction of all vertical lines so it fits our algorithm below
    segments = segments.map { |s| s.direction == :vertical ? Segment.new(s.x2, s.y2, s.x1, s.y1) : s }
  end

  result = 1
  relevant_ys = segments.flat_map { |s| [s.y1, s.y2] }.uniq.sort
  y = relevant_ys.first
  relevant_ys.each_with_index do |y, i|
    vertical_lines = segments.select { |s| s.direction == :vertical && s.contains_y(y) }.sort_by(&:x1)
    horizontal_lines = segments.select { |s| s.direction == :horizontal && s.contains_y(y) }.sort_by(&:x1)

    raise "Excpected vertical lines!" if vertical_lines.empty?

    number_of_vertical_lines = vertical_lines.size
    lines_for_future = []

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

      lines_for_future += downwards_lines_for_future
      lines_for_future += upwards_lines_for_future
    end

    # Count the area between each "future pair" of down/up lines
    area_relevant_for_next_many_lines = 0
    lines_for_future.each_slice(2) do |down, up|
      raise "Expected a down/up pair! #{down} #{up}" if down.vertical_direction != :down || up.vertical_direction != :up
      area_relevant_for_next_many_lines += up.x1 - down.x1 + 1 # +1 because we want to include the endpoints
      # Discard any horizontal lines that are between the down/up pair
      horizontal_lines.reject! { |h| h.x2 >= down.x1 && h.x1 <= up.x1 }
    end

    # We also need to add the remaining horizontal lines, but exclude one of their endpoints
    horizontal_area_only_for_this_line = area_relevant_for_next_many_lines
    horizontal_lines.each do |line|
      min_x, max_x = [line.x1, line.x2].sort
      horizontal_area_only_for_this_line += max_x - min_x
    end

    result += horizontal_area_only_for_this_line

    next_relevant_y = relevant_ys[i+1]

    if next_relevant_y
      result += area_relevant_for_next_many_lines * (next_relevant_y - y - 1)
    else
      raise "Expected no more relevant lines" if !downwards_lines_for_future.empty? || !upwards_lines_for_future.empty?
    end

    y = next_relevant_y
  end

  result
end

commands_part1 = lines.map do |line|
  direction, amount, color = line.split(' ')
  [direction, amount.to_i]
end

puts "Part 1: #{solve(commands_part1)}"

commands_part2 = lines.map do |line|
  line =~ /\(\#([0-9a-f]{5})([0-3])\)/ or raise "Bad hex: #{hex}"
  amount, direction = $1, $2
  direction = {
    '0' => 'R',
    '1' => 'D',
    '2' => 'L',
    '3' => 'U'
  }[direction]
  amount = amount.to_i(16)
  [direction, amount]
end

puts "Part 2: #{solve(commands_part2)}"
