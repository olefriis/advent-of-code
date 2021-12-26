lines = File.readlines('input').map(&:strip)

Action = Struct.new(:onoff, :startx, :endx, :starty, :endy, :startz, :endz)
Interval = Struct.new(:starty, :endy)

IntervalStack = Struct.new(:x, :ranges) do
  def add(starty, endy)
    overlapping = ranges.select { |r| r.endy >= starty && r.starty <= endy }
    if overlapping.empty?
      ranges << Interval.new(starty, endy)
    else
      overlapping.each { |r| ranges.delete(r) }
      new_starty = [starty, *overlapping.map(&:starty)].min
      new_endy = [endy, *overlapping.map(&:endy)].max
      ranges << Interval.new(new_starty, new_endy)
    end
  end

  def remove(starty, endy)
    overlapping = ranges.select { |r| r.endy >= starty && r.starty <= endy }
    overlapping.each do |r|
      ranges.delete(r)
      if r.starty < starty && r.endy > endy
        # We are removing an internal part of r
        ranges << Interval.new(r.starty, starty)
        ranges << Interval.new(endy, r.endy)
      elsif r.starty < starty
        # We are removing the start of r
        ranges << Interval.new(r.starty, starty)
      elsif r.endy > endy
        # We are removing the end of r
        ranges << Interval.new(endy, r.endy)
      end
      # ...and if we didn't fall into any of the above cases, we are removing the whole thing
    end
  end

  def value
    ranges.map {|r| r.endy - r.starty }.sum
  end
end

Map2dWithZCoordinate = Struct.new(:z, :map2d) do
  def add(startx, endx, starty, endy)
    ensure_intervals_at(startx)
    ensure_intervals_at(endx)

    # Now add the new interval to all interval stacks
    map2d.select { |interval| interval.x >= startx && interval.x < endx }.each do |intervals|
      intervals.add(starty, endy)
    end
  end

  def remove(startx, endx, starty, endy)
    ensure_intervals_at(startx)
    ensure_intervals_at(endx)

    # Now remove the new interval from all interval stacks
    map2d.select { |interval| interval.x >= startx && interval.x < endx }.each do |interval|
      interval.remove(starty, endy)
    end
  end

  def value
    map2d.each_cons(2).map { |first, second| (second.x - first.x) * first.value }.sum
  end

  def ensure_intervals_at(x)
    if map2d.empty?
      map2d << IntervalStack.new(x, [])
    else
      first_position_after_x = nil
      map2d.each_with_index do |interval, index|
        return if interval.x == x # We already have it!
        if interval.x > x
          # We need to insert it before this one
          first_position_after_x = index
          break
        end
      end
      if first_position_after_x
        if first_position_after_x == 0
          # Add at the beginning
          map2d.insert(0, IntervalStack.new(x, []))
        else
          # Add in the middle
          intervals_before_x = map2d[first_position_after_x - 1]
          map2d.insert(first_position_after_x, IntervalStack.new(x, intervals_before_x.ranges.dup))
        end
      else
        # Add at the end
        intervals_before_x = map2d[-1]
        map2d << IntervalStack.new(x, intervals_before_x.ranges.dup)
      end
    end
  end
end

actions = lines.map do |line|
  onoff, cube = line.split(' ')
  ranges = cube.split(',')
  ranges = ranges
    .map { |r| r.split('=').last }
    .map { |r| r.split('..').map(&:to_i) }

  Action.new(onoff, ranges[0][0], ranges[0][1], ranges[1][0], ranges[1][1], ranges[2][0], ranges[2][1])
end

# Prepare a stack of 2D maps, one for each relevant z coordinate
all_z_values = (actions.map(&:startz) + actions.map {|a| a.endz + 1}).uniq.sort
stack_of_2d_maps = all_z_values.map { |z| Map2dWithZCoordinate.new(z, []) }

actions.each do |action|
  puts "Action: #{action}"

  startx, endx = action.startx, action.endx + 1
  starty, endy = action.starty, action.endy + 1
  startz, endz = action.startz, action.endz + 1

  # For each 2D map from startz to endz, either add or remove a rectangle
  stack_of_2d_maps.each do |map2d|
    if map2d.z >= startz && map2d.z < endz
      if action.onoff == 'on'
        map2d.add(startx, endx, starty, endy)
      else
        map2d.remove(startx, endx, starty, endy)
      end
    end
  end
end

sum = 0
stack_of_2d_maps.each_cons(2) { |first, second| sum += (second.z - first.z) * first.value }

puts sum
