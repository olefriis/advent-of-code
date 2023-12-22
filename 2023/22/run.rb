require 'pry'
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

  def debug
    result = "Brick #{number} is supporting #{supporting.map(&:number)}"
    supporting.each do |supporting|
      result += "\n  Brick #{supporting.number} is supported by #{supporting.on_top_of.map(&:number).join(', ')}"
    end
    result
  end

  def move_to!(new_height)
    previous_height = start_p[2]
    diff = new_height - previous_height
    start_p[2] += diff
    end_p[2] += diff
  end
end

bricks = []
lines.each_with_index do |line, i|
  start_p, end_p = line.split('~').map {|p| p.split(',').map(&:to_i)}
  raise "More than one coordinate changed in #{i}" if start_p.zip(end_p).select {|s, e| e != s}.count > 1
  bricks << Brick.new(i, start_p, end_p, Set.new, Set.new)
end
bricks.sort_by! {|b| b.start_p[2]}

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
  puts "Brick: #{brick.number}"
  covered_xy = brick.xy_points_covered
  max_height = covered_xy.map {|xy| heights[xy]}.max # We will put our brick on this level
  puts "Max height: #{max_height}"
  covered_xy.each do |xy|
    puts "Covering #{xy}"
    if heights[xy] == max_height
      current_brick = current_bricks[xy]
      puts "On top of #{current_brick.number}"
      brick.on_top_of << current_brick
      current_brick.supporting << brick
    end
    heights[xy] = max_height + brick.height
    brick.move_to!(max_height + 1)
    current_bricks[xy] = brick
  end
end

bricks.each { |b| puts b.debug }

can_be_removed = bricks.select do |brick|
  if brick.supporting.empty?
    true
  else
    ok = true
    brick.supporting.each do |supported_brick|
      raise "Supported brick is not supported..." unless supported_brick.on_top_of.include?(brick)
      ok = false if supported_brick.on_top_of.count == 1
    end
    ok
  end
end

puts "Part 1: #{can_be_removed.uniq.count}"

# Process the bricks from the top down, so we can cache some results as we "go down" the blocks.
# As we try to remove each block, we will record which other blocks that affects, so we can re-use
# this information for some of the blocks further down.
bricks.sort_by! {|b| b.start_p[2]}.reverse!
affected_bricks = {}

part2_a = []
bricks.each_with_index do |brick, i|
  puts "Brick #{i}"
  falling = Set.new
  falling << brick
  changed = true
  while changed
    puts " iterating - #{falling.count} falling"
    changed = false
    new_falling = Set.new
    falling.each do |falling_brick|
      known_affected = affected_bricks[falling_brick]
      # "Supercharge" or iteration. We know that by removing this brick, we will affect all the bricks that are affected by this brick.
      if known_affected
        known_affected.each do |affected_brick|
          new_falling << affected_brick if !falling.include?(affected_brick)
        end
      end
      falling_brick.supporting.each do |supported_brick|
        # This will also fall if it is only on top of other falling bricks
        remaining_stable_bricks = supported_brick.on_top_of - falling
        new_falling << supported_brick if remaining_stable_bricks.empty? && !falling.include?(supported_brick)
      end
    end
    changed = new_falling.count > 0
    new_falling.each {|f| falling << f}
  end
  affected_bricks[brick] = falling

  part2_a << falling.count - 1
end

puts "Part 2: #{part2_a.sum}"
