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
    raise "Hey, wrong ends" if end_p[2] < start_p[2]
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

heights = {}
current_bricks = {}

# Get the floor in place first
floor = Brick.new(-1, nil, nil, Set.new, Set.new)
min_x.upto(max_x) do |x|
  min_y.upto(max_y) do |y|
    heights[[x, y]] = 1
    current_bricks[[x, y]] = floor
  end
end

bricks.each do |brick|
  covered_xy = brick.xy_points_covered
  max_height = covered_xy.map {|xy| heights[xy]}.max # We will put our brick on this level
  covered_xy.each do |xy|
    if heights[xy] == max_height
      current_brick = current_bricks[xy]
      brick.on_top_of << current_brick
      current_brick.supporting << brick
    end
    heights[xy] = max_height + brick.height
    brick.move_to!(max_height + 1)
    current_bricks[xy] = brick
  end
end

can_be_removed = bricks.select { |brick| brick.supporting.none? { |supported_brick| supported_brick.on_top_of.count == 1 } }
puts "Part 1: #{can_be_removed.uniq.count}"

# Process the bricks from the top down, so we can cache some results as we "go down" the blocks.
# As we try to remove each block, we will record which other blocks that affects, so we can re-use
# this information for some of the blocks further down.
bricks.sort_by! {|b| b.start_p[2]}.reverse!
affected_bricks = {}

falling_bricks_counts = bricks.each_with_index.map do |brick, i|
  falling = [brick].to_set
  seen = falling.dup
  changed = true
  while changed
    changed = false
    new_falling = Set.new
    falling.each do |falling_brick|
      known_affected = affected_bricks[falling_brick]
      # "Supercharge" or iteration. We know that by removing this brick, we will affect all the bricks that are affected by this brick.
      if known_affected
        known_affected.each do |affected_brick|
          new_falling << affected_brick unless seen.include?(affected_brick)
        end
      end
      falling_brick.supporting.each do |supported_brick|
        # This will also fall if it is only on top of other falling bricks
        #remaining_stable_bricks = supported_brick.on_top_of - falling
        new_falling << supported_brick if seen.superset?(supported_brick.on_top_of) && !seen.include?(supported_brick)
      end
    end
    changed = new_falling.count > 0
    new_falling.each {|f| seen << f}
    falling = new_falling
  end
  affected_bricks[brick] = falling
  seen.count - 1
end

puts "Part 2: #{falling_bricks_counts.sum}"
