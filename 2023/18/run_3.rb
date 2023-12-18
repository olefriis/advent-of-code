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

x_to_actual_x = segments.flat_map { |s| [s.x1, s.x2] }.flat_map { |x| [x-1, x, x+1] }.uniq.sort
y_to_actual_y = segments.flat_map { |s| [s.y1, s.y2] }.flat_map { |y| [y-1, y, y+1] }.uniq.sort

grid = []
y_to_actual_y.each do |y|
  line = []
  x_to_actual_x.each do |x|
    line << nil
  end
  grid << line
end

# Now draw all the segments
segments.each do |segment|
  begin_actual_y, end_actual_y = [segment.y1, segment.y2].minmax
  begin_actual_x, end_actual_x = [segment.x1, segment.x2].minmax

  begin_fake_x = x_to_actual_x.index(begin_actual_x)
  end_fake_x = x_to_actual_x.index(end_actual_x)
  begin_fake_y = y_to_actual_y.index(begin_actual_y)
  end_fake_y = y_to_actual_y.index(end_actual_y)

  grid[begin_fake_y][begin_fake_x] = '#'
  # Draw to the right
  while begin_fake_x < end_fake_x
    grid[begin_fake_y][begin_fake_x] = '#'
    begin_fake_x += 1
  end
  grid[begin_fake_y][begin_fake_x] = '#'

  # Draw down
  while begin_fake_y < end_fake_y
    grid[begin_fake_y][begin_fake_x] = '#'
    begin_fake_y += 1
  end
  grid[begin_fake_y][begin_fake_x] = '#'
end

# Do flood fill
edge = [[0, 0]]
while !edge.empty?
  new_edge = Set.new
  edge.each do |px, py|
    DIRECTIONS.values.each do |dx, dy|
      px2 = px + dx
      py2 = py + dy
      next if px2 < 0 || py2 < 0 || px2 >= grid[0].length || py2 >= grid.length
      next if grid[py2][px2]
      grid[py2][px2] = '.'
      new_edge << [px2, py2]
    end
  end
  edge = new_edge
end

grid.each do |line|
  puts line.map { |e| e || ' ' }.join
end

part2 = 0
grid.each_with_index do |line, y|
  line.each_with_index do |entry, x|
    if [nil, '#' ].include?(entry)
      width = x_to_actual_x[x+1] - x_to_actual_x[x]
      height = y_to_actual_y[y+1] - y_to_actual_y[y]
      part2 += width * height
    end
  end
end

puts "Part 2: #{part2}"