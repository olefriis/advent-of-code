lines = File.readlines('09/input').map(&:strip)
positions = lines.map { |line| line.split(',').map(&:to_i) }

real_x_positions = positions.map { |x, _| x }.sort.uniq
real_y_positions = positions.map { |_, y| y }.sort.uniq

puts "X positions: #{real_x_positions.length}"
puts "Y positions: #{real_y_positions.length}"

fake_x_positions = {}
real_x_positions.each_with_index do |x, index|
  fake_x_positions[x] = (index + 1) * 2
end
fake_y_positions = {}
real_y_positions.each_with_index do |y, index|
  fake_y_positions[y] = (index + 1) * 2
end

min_fake_x, max_fake_x = fake_x_positions.values.minmax
min_fake_y, max_fake_y = fake_y_positions.values.minmax

# Make a border around the whole thing, just to be on the safe side
min_fake_x -= 2
max_fake_x += 2
min_fake_y -= 2
max_fake_y += 2

fake_positions = positions.map do |x, y|
  [fake_x_positions[x], fake_y_positions[y]]
end

grid = Set.new
fake_positions.length.times do |i|
  start_position, end_position = fake_positions[i], fake_positions[(i+1) % fake_positions.length]
  if start_position[1] == end_position[1]
    # Horizontal line
    start_at, end_at = [start_position[0], end_position[0]].minmax
    start_at.upto(end_at) do |x|
      grid.add([x, start_position[1]])
    end
  else
    # Vertical line
    start_at, end_at = [start_position[1], end_position[1]].minmax
    start_at.upto(end_at) do |y|
      grid.add([start_position[0], y])
    end
  end
end

# Now fill the grid. Do it from the outside.
# Kind of "make a negative" of the shape.
filled = Set.new
edge = [[min_fake_x, min_fake_y]]
while edge.any?
  current = edge.pop
  next if filled.include?(current)
  next if grid.include?(current)
  filled.add(current)

  x, y = current
  # Add neighbors
  [[x-1, y], [x+1, y], [x, y-1], [x, y+1]].each do |nx, ny|
    if nx >= min_fake_x && nx <= max_fake_x && ny >= min_fake_y && ny <= max_fake_y
      edge.push([nx, ny])
    end
  end
end

# Complete the original grid with all positions not in filled
0.upto(max_fake_x) do |x|
  0.upto(max_fake_y) do |y|
    unless filled.include?([x, y]) || grid.include?([x, y])
      grid.add([x, y])
    end
  end
end

part_2 = 0
# Now try out all the rectangles
puts "Trying out all the rectangles"
positions.combination(2).map do |(x1, y1), (x2, y2)|
  fake_x1, fake_y1 = fake_x_positions[x1], fake_y_positions[y1]
  fake_x2, fake_y2 = fake_x_positions[x2], fake_y_positions[y2]

  left, right = [fake_x1, fake_x2].minmax
  top, bottom = [fake_y1, fake_y2].minmax

  # Check if all positions within the rectangle are in the grid
  all_in_grid = true
  left.upto(right) do |x|
    top.upto(bottom) do |y|
      unless grid.include?([x, y])
        all_in_grid = false
        break
      end
    end
    break unless all_in_grid
  end

  if all_in_grid
    original_area = ( (x2 - x1).abs + 1 ) * ( (y2 - y1).abs + 1 )
    part_2 = [part_2, original_area].max
  end
end
puts "Part 2: #{part_2}"