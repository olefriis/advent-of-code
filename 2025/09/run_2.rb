lines = File.readlines('09/input').map(&:strip)
positions = lines.map { |line| line.split(',').map(&:to_i) }.to_set

min_y, max_y = positions.map { |_, y| y }.minmax
puts "Y range: #{min_y} to #{max_y}: #{max_y - min_y + 1} rows"

puts "At bottom: #{positions.select { |_, y| y == max_y }.to_a}"

top_positions = positions.select {|_, y| y == min_y}
puts "At top: #{top_positions.to_a}"
current_left, current_right = top_positions.map { |x, _| x }.minmax

part_2 = 0

interesting_y_positions = positions.map { |_, y| y }.sort.uniq
pairs_at_rows = {}
interesting_y_positions.each do |y|
  row_positions = positions.select { |_, py| py == y }.map { |px, _| px }.sort
  pairs_at_rows[y] = row_positions
end

def within_bounds(bounds, top_point, bottom_point)
  left, right = [top_point[0], bottom_point[0]].minmax
  left >= bounds[0] && right <= bounds[1]
end

limits_x = top_positions.map { |x, _| x }.minmax
rectangles = []  # Each entry stores the top (left/right) corner and the bottom (right/left) corner
#puts "Starting with limits #{limits_x}"
interesting_y_positions.each_with_index do |y, index|
  row_positions = pairs_at_rows[y]
  raise "Something is up: #{row_positions}" unless row_positions.count == 2

  #puts "Row #{y}"
  old_limits = limits_x.dup
  if index > 0
    if row_positions[1] == limits_x[0]
      puts "Expanding to left"
      limits_x[0] = row_positions[0]
    elsif row_positions[0] == limits_x[1]
      puts "Expanding to right"
      limits_x[1] = row_positions[1]
    elsif row_positions[1] == limits_x[1]
      puts "Shrinking from right"
      limits_x[1] = row_positions[0]
    elsif row_positions[0] == limits_x[0]
      puts "Shrinking from left"
      limits_x[0] = row_positions[1]
    else
      raise "Limits broken at row #{y}: #{row_positions}, current limits: #{limits_x}"
    end
    #puts " New limits: #{limits_x}"
  end

  limits_for_this_row = [[old_limits[0], limits_x[0]].min, [old_limits[1], limits_x[1]].max]
  #puts "Limits for this row: #{limits_for_this_row}"

  #puts "#{y}: #{row_positions}. Current rectangles: #{rectangles}"
  interesting_points_after_this = positions.select {|px, py| py > y && px >= limits_x[0] && px <= limits_x[1]}
  new_rectangles = interesting_points_after_this.flat_map do |px, py|
    row_positions.map do |row_px|
      #puts " New rectangle from (#{row_px}, #{y}) to (#{px}, #{py})"
      [[row_px, y], [px, py]]
    end
  end

  rectangles_to_finish = rectangles.select {|top_point, bottom_point| bottom_point[1] == y}
  rectangles_to_finish.each do |top_point, bottom_point|
    next unless within_bounds(limits_for_this_row, top_point, bottom_point)

    area = ((bottom_point[0] - top_point[0]).abs + 1) * (y - top_point[1] + 1)
    puts "Finalized rectangle #{top_point} to #{bottom_point}: area #{area}"
    part_2 = [part_2, area].max
  end

  invalid_rectangles = rectangles.select do |top_point, bottom_point|
    !within_bounds(limits_x, top_point, bottom_point)
  end
  rectangles = rectangles - invalid_rectangles - rectangles_to_finish + new_rectangles
end

puts "Part 2: #{part_2}"