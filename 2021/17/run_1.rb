require 'pry'
line = File.readlines('input').first.strip
line =~ /^target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)$/

x1, x2, y1, y2 = $1.to_i, $2.to_i, $3.to_i, $4.to_i

puts "x1: #{x1}, x2: #{x2}, y1: #{y1}, y2: #{y2}"

def trajectory_x_ends_in?(trajectory_x, x1, x2)
  x = 0
  while x <= x2
    return true if x >= x1 && x <= x2
    x += trajectory_x
    trajectory_x -= 1
    return false if trajectory_x == 0
  end
  false
end

def valid_trajectory?(trajectory_x, trajectory_y, x1, x2, y1, y2)
  x, y = 0, 0
  highest_y = 0
  while y >= y1
    #puts "x: #{x}, y: #{y}, trajectory_x: #{trajectory_x}, trajectory_y: #{trajectory_y}"
    return [true, highest_y] if x >= x1 && x <= x2 && y >= y1 && y <= y2
    #puts "No hit"
    highest_y = [y, highest_y].max
    x += trajectory_x
    y += trajectory_y
    trajectory_x -= 1 if trajectory_x > 0
    trajectory_y -= 1
  end
  [false, nil]
end

possible_trajectories_x = (1..x2).to_a.filter { |trajectory_x| trajectory_x_ends_in?(trajectory_x, x1, x2) }

#binding.pry
max_height = 0
possible_trajectories_x.each do |trajectory_x|
  #puts "Trying x: #{trajectory_x}"
  (0...1000).each do |trajectory_y|
    is_valid, max_height_for_trajectory = valid_trajectory?(trajectory_x, trajectory_y, x1, x2, y1, y2)
    if is_valid && max_height_for_trajectory > max_height
      puts "New max: #{max_height_for_trajectory} for #{trajectory_x}, #{trajectory_y}"
      max_height = max_height_for_trajectory
    end
  end
end

puts max_height
