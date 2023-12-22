lines = File.readlines("22/input").map(&:strip)

Brick = Struct.new(:number, :start_p, :end_p, :supporting, :on_top_of) do
  def xy_points_covered
    pos_xy = [start_p[0], start_p[1]]
    end_xy = [end_p[0], end_p[1]]
    result = []
    while pos_xy != end_xy
      result << pos_xy.dup
      pos_xy[0] += 1 if pos_xy[0] < end_xy[0]
      pos_xy[1] += 1 if pos_xy[1] < end_xy[1]
    end
    result << end_xy
    result
  end

  def height
    end_p[2] - start_p[2] + 1
  end

  def move_to!(new_height)
    previous_height = start_p[2]
    diff = new_height - previous_height
    start_p[2] += diff
    end_p[2] += diff
  end
end

bricks = lines.each_with_index.map do |line, i|
  start_p, end_p = line.split('~').map {|p| p.split(',').map(&:to_i)}
  Brick.new(i, start_p, end_p, Set.new, Set.new)
end.sort_by {|b| b.start_p[2]}

min_x, max_x = (bricks.map {|b| b.start_p[0]} + bricks.map {|b| b.end_p[0]}).minmax
min_y, max_y = (bricks.map {|b| b.start_p[1]} + bricks.map {|b| b.end_p[1]}).minmax

current_heights = {}
current_bricks = {}

# Get the floor in place first
floor = Brick.new(-1, nil, nil, Set.new, Set.new)
min_x.upto(max_x) do |x|
  min_y.upto(max_y) do |y|
    current_heights[[x, y]] = 1
    current_bricks[[x, y]] = floor
  end
end

# Let every brick fall into place
bricks.each do |brick|
  covered_xy = brick.xy_points_covered
  max_height = covered_xy.map {|xy| current_heights[xy]}.max # We will put our brick on this level
  covered_xy.each do |xy|
    if current_heights[xy] == max_height
      current_brick = current_bricks[xy]
      brick.on_top_of << current_brick
      current_brick.supporting << brick
    end
    current_heights[xy] = max_height + brick.height
    brick.move_to!(max_height + 1)
    current_bricks[xy] = brick
  end
end

# Then calculate the number of affected bricks when removing each brick
affected_bricks_counts = bricks.map do |brick|
  edge = [brick].to_set
  seen = edge.dup
  loop do
    new_edge = Set.new
    edge.each do |falling_brick|
      falling_brick.supporting.each do |supported_brick|
        # This will also fall if it is only on top of other falling bricks
        new_edge << supported_brick if seen >= supported_brick.on_top_of && !seen.include?(supported_brick)
      end
    end
    break if new_edge.empty?
    seen += new_edge
    edge = new_edge
  end
  seen.count - 1
end

puts "Part 1: #{affected_bricks_counts.count(0)}"
puts "Part 2: #{affected_bricks_counts.sum}"
